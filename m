Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D48D5977D
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Jun 2019 11:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1Jau (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Jun 2019 05:30:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:56564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbfF1Jau (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 05:30:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C1C8AB5F;
        Fri, 28 Jun 2019 09:30:49 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sweil@redhat.com>, "Yan\, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: initialize superblock s_time_gran to 1
In-Reply-To: <c7fc812e444fee2fa7243044da5a48d1ad5b63ab.camel@kernel.org> (Jeff
        Layton's message of "Thu, 27 Jun 2019 12:10:25 -0400")
References: <20190627135122.12817-1-lhenriques@suse.com>
        <0459c2a46200194c14b7474f55071b12fbc3d594.camel@kernel.org>
        <alpine.DEB.2.11.1906271543440.17148@piezo.novalocal>
        <c7fc812e444fee2fa7243044da5a48d1ad5b63ab.camel@kernel.org>
Date:   Fri, 28 Jun 2019 10:30:48 +0100
Message-ID: <87a7e2dpkn.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Thu, 2019-06-27 at 15:44 +0000, Sage Weil wrote:
>> On Thu, 27 Jun 2019, Jeff Layton wrote:
>> > On Thu, 2019-06-27 at 14:51 +0100, Luis Henriques wrote:
>> > > Having granularity set to 1us results in having inode timestamps with a
>> > > accurancy different from the fuse client (i.e. atime, ctime and mtime will
>> > > always end with '000').  This patch normalizes this behaviour and sets the
>> > > granularity to 1.
>> > > 
>> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> > > ---
>> > >  fs/ceph/super.c | 2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > > 
>> > > Hi!
>> > > 
>> > > As far as I could see there are no other side-effects of changing
>> > > s_time_gran but I'm really not sure why it was initially set to 1000 in
>> > > the first place so I may be missing something.
>> > > 
>> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> > > index d57fa60dcd43..35dd75bc9cd0 100644
>> > > --- a/fs/ceph/super.c
>> > > +++ b/fs/ceph/super.c
>> > > @@ -980,7 +980,7 @@ static int ceph_set_super(struct super_block *s, void *data)
>> > >     s->s_d_op = &ceph_dentry_ops;
>> > >     s->s_export_op = &ceph_export_ops;
>> > >  
>> > > -   s->s_time_gran = 1000;  /* 1000 ns == 1 us */
>> > > +   s->s_time_gran = 1;
>> > >  
>> > >     ret = set_anon_super(s, NULL);  /* what is that second arg for? */
>> > >     if (ret != 0)
>> > 
>> > 
>> > Looks like it was set that way since the client code was originally
>> > merged. Was this an earlier limitation of ceph that is no longer
>> > applicable?
>> > 
>> > In any case, I see no need at all to keep this at 1000, so:
>> 
>> As long as the encoded on-write time value is at ns resolution, I 
>> agree!  No recollection of why I did this :(
>> 
>> Reviewed-by: Sage Weil <sage@redhat.com>
>
> Good enough for me. I went ahead and merged this into the testing
> branch. Assuming nothing breaks, this should make v5.3.

Awesome, thanks.  AFAICS it shouldn't break anything, specially because
the fuse client seems to be using ns resolution too.  But yeah
unexpected side-effects show up in unexpected ways :-)

Cheers,
-- 
Luis
