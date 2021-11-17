Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD49454737
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 14:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbhKQNbL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 08:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237472AbhKQNbI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 08:31:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E4BE61B1B;
        Wed, 17 Nov 2021 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637155690;
        bh=Sq7GcIGoazaj4LWWxU0GfXcD/wru+TfJzzkBLCHUavw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=srnLmpZRj4EKojRxNRQ7aAC+Ths5UgTF3y/saTiBDe+XQd/gZcndo2ripuxPcqa9o
         +02OISB5VGHnG3kPO9HnBnheV2sEVlZNU7eX/hDyIXIz7hhSeGMqTyqIXkIwBODjRF
         GM+XoGAph/tv3ak6xqG5HYzrSucUi+zioNUQRlNIZyHygnlVEYuTwBucWlo/+PAloi
         BMtvfm7oxuhMgdC96SxM4cvBCPaU3BmYwvN5t9TD8Mf9UiHB6i9vWBj//lW1e/p+us
         gVnECqwfQ6DdTdhdL0pEXd6Bw1W+plbhYm0raTF5B5qwOJwHR9K/Zc5WccOHQR+H5Z
         w+B0EOuzHEXNQ==
Message-ID: <e49bbb32e8c76e441c6d24f98774187c4e913a22.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size
 doesn't change
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 17 Nov 2021 08:28:08 -0500
In-Reply-To: <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
References: <20211116092002.99439-1-xiubli@redhat.com>
         <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
         <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
> On 11/17/21 4:06 AM, Jeff Layton wrote:
> > On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > In case truncating a file to a smaller sizeA, the sizeA will be kept
> > > in truncate_size. And if truncate the file to a bigger sizeB, the
> > > MDS will only increase the truncate_seq, but still using the sizeA as
> > > the truncate_size.
> > > 
> > Do you mean "kept in ci->i_truncate_size" ?
> 
> Sorry for confusing. It mainly will be kept in the MDS side's 
> CInode->inode.truncate_size. And also will be propagated to all the 
> clients' ci->i_truncate_size member.
> 
> The MDS will only change CInode->inode.truncate_size when truncating a 
> smaller size.
> 
> 
> > If so, is this really the
> > correct fix? I'll note this in the sources:
> > 
> >          u32 i_truncate_seq;        /* last truncate to smaller size */
> >          u64 i_truncate_size;       /*  and the size we last truncated down to */
> > 
> > Maybe the MDS ought not bump the truncate_seq unless it was truncating
> > to a smaller size? If not, then that comment seems wrong at least.
> 
> Yeah, the above comments are inconsistent with what the MDS is doing.
> 
> Okay, I missed reading the code, I found in MDS that is introduced by 
> commit :
> 
>       bf39d32d936 mds: bump truncate seq when fscrypt_file changes
> 
> With the size handling feature support, I think this commit will make no 
> sense any more since we will calculate the 'truncating_smaller' by not 
> only comparing the new_size and old_size, which both are rounded up to 
> FSCRYPT BLOCK SIZE, will also check the 'req->get_data().length()' if 
> the new_size and old_size are the same.
> 
> 
> > 
> > > So when filling the inode it will truncate the pagecache by using
> > > truncate_sizeA again, which makes no sense and will trim the inocent
> > > pages.
> > > 
> > Is there a reproducer for this? It would be nice to put something in
> > xfstests for it if so.
> 
> In xfstests' generic/075 has already testing this, but i didn't see any 
> issue it reproduce.
> 
> I just found this strange logs when it's doing 
> something like:
> 
> truncateA 0x10000 --> 0x2000
> 
> truncateB 0x2000   --> 0x8000
> 
> truncateC 0x8000   --> 0x6000
> 
> For the truncateC, the log says:
> 
> ceph:  truncate_size 0x2000 -> 0x6000
> 
> 
> The problem is that the truncateB will also do the vmtruncate by using 
> the 0x2000 instead, the vmtruncate will not flush the dirty pages to the 
> OSD and will just discard them from the pagecaches. Then we may lost 
> some new updated data in case there has any write before the truncateB 
> in range [0x2000, 0x8000).
> 
> 

Is that reproducible without the fscrypt size handling changes? I
haven't seen generic/075 fail on stock kernels.

If this is a generic bug, then we should go ahead and fix it in
mainline. If it's a problem only with fscrypt enabled, then let's plan
to roll this patch into those changes.

> 
> 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/inode.c | 5 +++--
> > >   1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 1b4ce453d397..b4f784684e64 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
> > >   			 * don't hold those caps, then we need to check whether
> > >   			 * the file is either opened or mmaped
> > >   			 */
> > > -			if ((issued & (CEPH_CAP_FILE_CACHE|
> > > +			if (ci->i_truncate_size != truncate_size &&
> > > +			    ((issued & (CEPH_CAP_FILE_CACHE|
> > >   				       CEPH_CAP_FILE_BUFFER)) ||
> > >   			    mapping_mapped(inode->i_mapping) ||
> > > -			    __ceph_is_file_opened(ci)) {
> > > +			    __ceph_is_file_opened(ci))) {
> > >   				ci->i_truncate_pending++;
> > >   				queue_trunc = 1;
> > >   			}
> 

-- 
Jeff Layton <jlayton@kernel.org>
