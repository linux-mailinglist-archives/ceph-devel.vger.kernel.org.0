Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0058633
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2019 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF0Poe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jun 2019 11:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfF0Poe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:44:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C23F5F79B;
        Thu, 27 Jun 2019 15:44:34 +0000 (UTC)
Received: from ovpn-112-33.rdu2.redhat.com (ovpn-112-33.rdu2.redhat.com [10.10.112.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4021660BE0;
        Thu, 27 Jun 2019 15:44:32 +0000 (UTC)
Date:   Thu, 27 Jun 2019 15:44:31 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@kernel.org>
cc:     Luis Henriques <lhenriques@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: initialize superblock s_time_gran to 1
In-Reply-To: <0459c2a46200194c14b7474f55071b12fbc3d594.camel@kernel.org>
Message-ID: <alpine.DEB.2.11.1906271543440.17148@piezo.novalocal>
References: <20190627135122.12817-1-lhenriques@suse.com> <0459c2a46200194c14b7474f55071b12fbc3d594.camel@kernel.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 27 Jun 2019 15:44:34 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 27 Jun 2019, Jeff Layton wrote:
> On Thu, 2019-06-27 at 14:51 +0100, Luis Henriques wrote:
> > Having granularity set to 1us results in having inode timestamps with a
> > accurancy different from the fuse client (i.e. atime, ctime and mtime will
> > always end with '000').  This patch normalizes this behaviour and sets the
> > granularity to 1.
> > 
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Hi!
> > 
> > As far as I could see there are no other side-effects of changing
> > s_time_gran but I'm really not sure why it was initially set to 1000 in
> > the first place so I may be missing something.
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index d57fa60dcd43..35dd75bc9cd0 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -980,7 +980,7 @@ static int ceph_set_super(struct super_block *s, void *data)
> >  	s->s_d_op = &ceph_dentry_ops;
> >  	s->s_export_op = &ceph_export_ops;
> >  
> > -	s->s_time_gran = 1000;  /* 1000 ns == 1 us */
> > +	s->s_time_gran = 1;
> >  
> >  	ret = set_anon_super(s, NULL);  /* what is that second arg for? */
> >  	if (ret != 0)
> 
> 
> Looks like it was set that way since the client code was originally
> merged. Was this an earlier limitation of ceph that is no longer
> applicable?
> 
> In any case, I see no need at all to keep this at 1000, so:

As long as the encoded on-write time value is at ns resolution, I 
agree!  No recollection of why I did this :(

Reviewed-by: Sage Weil <sage@redhat.com>
