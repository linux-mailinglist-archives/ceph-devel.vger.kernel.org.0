Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B268725B36
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbjFGKAr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 06:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239728AbjFGKAq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 06:00:46 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AD91982
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 03:00:44 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-977d55ac17bso604465466b.3
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 03:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686132043; x=1688724043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kn7/awlY1yfdfPIjS82LWY67GmH4YmSkjvBB/FBqncw=;
        b=NpCk8c8uPoToL3k52gSk3VmBn3xPNt5kOE0E+2craGB5PXedaNVOHpFTGCwnQSqQ+2
         SwvxQIW97KBpLZZbcPMly9ANqCL4BLW8uwzrzhP5Y7G4V5E4ZYA6v0n2lO2vGlTKFnkG
         S8aaCO2ixt/KJbrUem7TZWRihChkS2PCqJO7+wsc0YMnHl7yV3JXyIjHZq5qZ+1e0rKD
         9DeNxpgLxvzJtMjlgVMW1CJbQrGOLwt/iAepEYo6ToIMtkeRlep/qn2X5Ka4V7tj1XKC
         /eZEhKcx/WKqWouIRF4eSP0YJKWuOJ7kdLW4qxj23/P7lgtTyHTziMYkHJbDKDYk+Big
         rNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686132043; x=1688724043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn7/awlY1yfdfPIjS82LWY67GmH4YmSkjvBB/FBqncw=;
        b=Fr+/wUwFfdSUmVAgCFFay8ZbC/P1/ptP8hN1A6faiz474Wh/ErckuUaBXmKbeTdYSR
         U5yxZW2YNyEhLhBx1MF6cjaAC9awUyhKHLsFLqMK8YPI1sW5NYhhw83AYiKO1bSWjx7N
         fmz7WQF8AvWgqSb/zWDBx0qycBPzUqzgs2/YdyhzHfqL2EdHi6jUG0uKjiYBfMtNvB5D
         0DryBuI0sSlhFr4xphiKvGkbMLQvbjhhNUKJCuiHyOEUJHMV3r1475k80RUYdIRuB/T0
         lV0oy70j5JK3vGNbFBJWSGS9II61uIeZnea7LzSNbA2nL+1MvoXwBK1d8QWWf7ioxQeN
         wgew==
X-Gm-Message-State: AC+VfDxvgO4Sk1I2/SFsNp1/U2Zt/8cJ8ezlcx5+E2hMoFExCjzXYPTd
        rp9oGAaUrfIirGGdXJN63QMCLhtfKJWOomIGk7I=
X-Google-Smtp-Source: ACHHUZ5RGSA3j8WPdJebR61EvBZGNi5MGDWU4DqO9qsTXAVRj48Rho17Ek2Ad5Sz3g8jPGnpQ0B6bb74HZ9t7s5kGnk=
X-Received: by 2002:a17:907:969f:b0:977:eed1:453c with SMTP id
 hd31-20020a170907969f00b00977eed1453cmr5480780ejc.73.1686132043197; Wed, 07
 Jun 2023 03:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230606033212.1068823-1-xiubli@redhat.com> <87pm689asx.fsf@suse.de>
 <7ab9007b-763b-aacf-2297-62f1989e2efd@redhat.com> <87h6rj8wav.fsf@suse.de>
In-Reply-To: <87h6rj8wav.fsf@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 7 Jun 2023 12:00:30 +0200
Message-ID: <CAOi1vP9+rTB=EcfWNLxmB=67YYxxan=69A7AM67wMxh_4+feDA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ceph: fix fscrypt_destroy_keyring use-after-free bug
To:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 7, 2023 at 11:18=E2=80=AFAM Lu=C3=ADs Henriques <lhenriques@sus=
e.de> wrote:
>
> Xiubo Li <xiubli@redhat.com> writes:
>
> > On 6/6/23 17:53, Lu=C3=ADs Henriques wrote:
> >> xiubli@redhat.com writes:
> >>
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> V2:
> >>> - Improve the code by switching to wait_for_completion_killable_timeo=
ut()
> >>>    when umounting, at the same add one umount_timeout option.
> >> Instead of adding yet another (undocumented!) mount option, why not re=
-use
> >> the already existent 'mount_timeout' instead?  It's already defined an=
d
> >> kept in 'struct ceph_options', and the default value is defined with t=
he
> >> same value you're using, in CEPH_MOUNT_TIMEOUT_DEFAULT.
> >
> > This is for mount purpose. Is that okay to use the in umount case ?
>
> Yeah, you're probably right.  It's just that adding yet another knob for =
a
> corner case that probably will never be used and very few people will kno=
w
> about is never a good thing (IMO).  Anyway, I think that at least this ne=
w
> mount option needs to be mentioned in 'Documentation/filesystems/ceph.rst=
'.

It's OK and in fact preferrable to stick to mount_timeout to avoid new
knobs.  There is even a precedent for this: RBD uses mount_timeout both
when waiting for the latest osdmap (on "rbd map") and when tearing down
a watch (on "rbd unmap").

Thanks,

                Ilya
