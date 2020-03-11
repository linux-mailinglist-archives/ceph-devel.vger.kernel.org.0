Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02F181694
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 12:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCKLOb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 11 Mar 2020 07:14:31 -0400
Received: from out.roosit.eu ([212.26.193.44]:42570 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgCKLOb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 07:14:31 -0400
X-Greylist: delayed 2242 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 07:14:31 EDT
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136] (may be forged))
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 02BAavwd010420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 11 Mar 2020 11:36:58 +0100
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id 02BAauuJ020111;
        Wed, 11 Mar 2020 11:36:56 +0100
Date:   Wed, 11 Mar 2020 11:36:56 +0100
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     jlayton <jlayton@kernel.org>, lhenriques <lhenriques@suse.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Message-ID: <"H00000710016454f.1583923016.sx.f1-outsourcing.eu*"@MHS>
In-Reply-To: <20200311103142.GA6863@suse.com>
Subject: RE: [ceph-users] cephfs snap mkdir strange timestamp
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Sorry I am not really developer nor now details about POSIX/fs's. But if 
I may ask, why are you getting this time from the parent?



-----Original Message-----
Sent: 11 March 2020 11:32
To: Jeff Layton
Cc: Marc Roos; ceph-users; ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp

On Tue, Mar 10, 2020 at 01:39:29PM -0400, Jeff Layton wrote:
...
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/inode.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c index 
> > d01710a16a4a..f4e78ade0871 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -82,6 +82,8 @@ struct inode *ceph_get_snapdir(struct inode 
*parent)
> >  	inode->i_mode = parent->i_mode;
> >  	inode->i_uid = parent->i_uid;
> >  	inode->i_gid = parent->i_gid;
> > +	inode->i_mtime = parent->i_mtime;
> > +	inode->i_ctime = parent->i_ctime;
> >  	inode->i_op = &ceph_snapdir_iops;
> >  	inode->i_fop = &ceph_snapdir_fops;
> >  	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
> 
> What about the atime, and the ci->i_btime ?

Yeah, probably makes sense too, although the fuse client doesn't seem to 
touch atime (it does change btime, I missed that).  I'll send v2 in a 
bit.

Cheers,
--
Luis


