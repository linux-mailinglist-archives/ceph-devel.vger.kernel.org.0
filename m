Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA0A58B254
	for <lists+ceph-devel@lfdr.de>; Sat,  6 Aug 2022 00:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiHEWGq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Aug 2022 18:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241631AbiHEWGn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Aug 2022 18:06:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0AA911C20
        for <ceph-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659737199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlDrYXgDCUthUhiy73M1xjmezLFpu3vi4ADVmnqoFtM=;
        b=IZZ179FP/9ItWRAObFFeQllCWkBijN1zarTlzOSekT8m1c3A8iTVUmVaq6T5F7iDd3PmTb
        avuzWnfr3EWEru75w6hpPOONLYmtIZMJBYkkUKxndsoiko79gOZyrc2zPbaS+/0Crwpt9o
        StmUl+KbQGTVG1O0yGhpdxAnAfcClWo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-KJFWEwZfP1Wt5qRsPiu5nw-1; Fri, 05 Aug 2022 18:06:38 -0400
X-MC-Unique: KJFWEwZfP1Wt5qRsPiu5nw-1
Received: by mail-qk1-f200.google.com with SMTP id l15-20020a05620a28cf00b006b46997c070so2968365qkp.20
        for <ceph-devel@vger.kernel.org>; Fri, 05 Aug 2022 15:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=zlDrYXgDCUthUhiy73M1xjmezLFpu3vi4ADVmnqoFtM=;
        b=MyoARQ8UuO6sIPUXVaAKFHZVMr3XVjnT7Kh+eBPuyQgv44qf2Kwafj/LuH6gt1jHeP
         KMi5QPd4f3ZcDtE3lTtLyrwbzdWogmnn1KITGpgfHBS7YHiYdfie7mji8NydRLxwCpQK
         LxcsBPaP/kW6et7o+f5M2uFJeU4gN5tT4KtdvTCT0cW3frR0qDADeWE1/zIEF0xRScia
         bacHTWt1/yL6eQbvXwjmzo9pJE+TVu1aYekOaouUHrQUbFklM6QLpBft4wFzzD+5MDBz
         aAPsu2kpFPEkp5Ak9gulC58zDzS7Vt053HRMQKSIMwBVp0EqwkbziI/mfBMFfsfDnrIM
         5ZAQ==
X-Gm-Message-State: ACgBeo1vZVhhR6MlzwWAK8Wap2NQKNi/r0TU5gI/Gxy0c6VKZsQR1ly8
        r06pWAe1A26sQ5jS94FZq6lNNKOUxpf+oO+Wp9mMVBmGBD3NHGlPrR3hud1B2vXM8pLztnwTGTS
        9Ld4KTabO6OFEUU1MSC1JiA==
X-Received: by 2002:a05:620a:170e:b0:6b8:fa02:6110 with SMTP id az14-20020a05620a170e00b006b8fa026110mr6704341qkb.184.1659737198077;
        Fri, 05 Aug 2022 15:06:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xEDaXjDnYGgwNPYVw0vUMBp/ecTy5raNl40Xwriy8H7D/VAv8N6Y/Htlz8LTyvWjvxbIRbw==
X-Received: by 2002:a05:620a:170e:b0:6b8:fa02:6110 with SMTP id az14-20020a05620a170e00b006b8fa026110mr6704322qkb.184.1659737197860;
        Fri, 05 Aug 2022 15:06:37 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g18-20020a05620a40d200b006b5f9b7ac87sm4514981qko.26.2022.08.05.15.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 15:06:37 -0700 (PDT)
Message-ID: <c10e4aa381aea86bb51b005887533e28f9c7302b.camel@redhat.com>
Subject: Re: [RFC PATCH 1/4] vfs: report change attribute in statx for
 IS_I_VERSION inodes
From:   Jeff Layton <jlayton@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, dhowells@redhat.com,
        lczerner@redhat.com, bxue@redhat.com, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date:   Fri, 05 Aug 2022 18:06:36 -0400
In-Reply-To: <20220805220136.GG3600936@dread.disaster.area>
References: <20220805183543.274352-1-jlayton@kernel.org>
         <20220805183543.274352-2-jlayton@kernel.org>
         <20220805220136.GG3600936@dread.disaster.area>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-08-06 at 08:01 +1000, Dave Chinner wrote:
> On Fri, Aug 05, 2022 at 02:35:40PM -0400, Jeff Layton wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> >=20
> > Claim one of the spare fields in struct statx to hold a 64-bit change
> > attribute. When statx requests this attribute, do an
> > inode_query_iversion and fill the result in the field.
> >=20
> > Also update the test-statx.c program to fetch the change attribute as
> > well.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/stat.c                 | 7 +++++++
> >  include/linux/stat.h      | 1 +
> >  include/uapi/linux/stat.h | 3 ++-
> >  samples/vfs/test-statx.c  | 4 +++-
> >  4 files changed, 13 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/stat.c b/fs/stat.c
> > index 9ced8860e0f3..976e0a59ab23 100644
> > --- a/fs/stat.c
> > +++ b/fs/stat.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/compat.h>
> > +#include <linux/iversion.h>
> > =20
> >  #include <linux/uaccess.h>
> >  #include <asm/unistd.h>
> > @@ -118,6 +119,11 @@ int vfs_getattr_nosec(const struct path *path, str=
uct kstat *stat,
> >  	stat->attributes_mask |=3D (STATX_ATTR_AUTOMOUNT |
> >  				  STATX_ATTR_DAX);
> > =20
> > +	if ((request_mask & STATX_CHGATTR) && IS_I_VERSION(inode)) {
> > +		stat->result_mask |=3D STATX_CHGATTR;
> > +		stat->chgattr =3D inode_query_iversion(inode);
> > +	}
>=20
> If you're going to add generic support for it, shouldn't there be a
> generic test in fstests that ensures that filesystems that advertise
> STATX_CHGATTR support actually behave correctly? Including across
> mounts, and most importantly, that it is made properly stable by
> fsync?
>=20
> i.e. what good is this if different filesystems have random quirks
> that mean it can't be relied on by userspace to tell it changes have
> occurred?

Absolutely. Being able to better test the i_version field for consistent
behavior is a primary goal. I haven't yet written any yet, but we'd
definitely want something in xfstests if we decide this is worthwhile.
--=20
Jeff Layton <jlayton@redhat.com>

