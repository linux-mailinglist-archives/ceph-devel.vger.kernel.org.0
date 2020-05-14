Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53FF1D30D9
	for <lists+ceph-devel@lfdr.de>; Thu, 14 May 2020 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgENNP5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 May 2020 09:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgENNP4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 May 2020 09:15:56 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B327206DA;
        Thu, 14 May 2020 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589462156;
        bh=v6MXwV/gG1H4E+LPHWAerasj/q/Dsnckh5u8rtbYcbI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XB6Ugjlx1W02LH3VZWK0fqRmtjYZSNl3xW6tdtxis9HDm4ZOUr75Aq2XAHcOg2XDj
         EYLZkgbIWPq0x/CprqqaTBIrrj/qGQii0SrkXoVlo6d8P3nz7JPKXPOXRJmQOqTH1i
         M9Z22+FO6a0yNNOu7fSdROa1ZtoLKX87+Qg9RbSM=
Message-ID: <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 14 May 2020 09:15:54 -0400
In-Reply-To: <20200514124845.GA12559@suse.com>
References: <20200514111453.GA99187@suse.com>
         <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
         <20200514124845.GA12559@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-05-14 at 13:48 +0100, Luis Henriques wrote:
> On Thu, May 14, 2020 at 08:10:09AM -0400, Jeff Layton wrote:
> > On Thu, 2020-05-14 at 12:14 +0100, Luis Henriques wrote:
> > > Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> > > a file handle to dentry"), this fixes another corner case with
> > > name_to_handle_at/open_by_handle_at.  The issue has been detected by
> > > xfstest generic/467, when doing:
> > > 
> > >  - name_to_handle_at("/cephfs/myfile")
> > >  - open("/cephfs/myfile")
> > >  - unlink("/cephfs/myfile")
> > >  - open_by_handle_at()
> > > 
> > > The call to open_by_handle_at should not fail because the file still
> > > exists and we do have a valid handle to it.
> > > 
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > >  fs/ceph/export.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > index 79dc06881e78..8556df9d94d0 100644
> > > --- a/fs/ceph/export.c
> > > +++ b/fs/ceph/export.c
> > > @@ -171,12 +171,21 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
> > >  
> > >  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> > >  {
> > > +	struct ceph_inode_info *ci;
> > >  	struct inode *inode = __lookup_inode(sb, ino);
> > > +
> > >  	if (IS_ERR(inode))
> > >  		return ERR_CAST(inode);
> > >  	if (inode->i_nlink == 0) {
> > > -		iput(inode);
> > > -		return ERR_PTR(-ESTALE);
> > > +		bool is_open;
> > > +		ci = ceph_inode(inode);
> > > +		spin_lock(&ci->i_ceph_lock);
> > > +		is_open = __ceph_is_file_opened(ci);
> > > +		spin_unlock(&ci->i_ceph_lock);
> > > +		if (!is_open) {
> > > +			iput(inode);
> > > +			return ERR_PTR(-ESTALE);
> > > +		}
> > >  	}
> > >  	return d_obtain_alias(inode);
> > >  }
> > 
> > Thanks Luis. Out of curiousity, is there any reason we shouldn't ignore
> > the i_nlink value here? Does anything obviously break if we do?
> 
> Yes, the scenario described in commit 03f219041fdb is still valid, which
> is basically the same but without the extra open(2):
> 
>   - name_to_handle_at("/cephfs/myfile")
>   - unlink("/cephfs/myfile")
>   - open_by_handle_at()
> 

Ok, I guess we end up doing some delayed cleanup, and that allows the
inode to be found in that situation.

> The open_by_handle_at man page isn't really clear about these 2 scenarios,
> but generic/426 will fail if -ESTALE isn't returned.  Want me to add a
> comment to the code, describing these 2 scenarios?
> 

(cc'ing Amir since he added this test)

I don't think there is any hard requirement that open_by_handle_at
should fail in that situation. It generally does for most filesystems
due to the way they handle cleaning up unlinked inodes, but I don't
think it's technically illegal to allow the inode to still be found. If
the caller cares about whether it has been unlinked it can always test
i_nlink itself.

Amir, is this required for some reason that I'm not aware of?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

