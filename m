Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE763CF66
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 07:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiK3G4O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 01:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiK3G4L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 01:56:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4445215D
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669791294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKIPeexGrBZvrEr+XXCg6jGzD5iE9g+Y7DE5GJYcBvQ=;
        b=c/frZ1swsnhR3ctroGpcEX1xcRHLwQ1UA5GNxXWcP1RDBBBl3ZRVzmTy5lq59szPPtQap9
        oN9adDP0SzaW9q+Vk3vYr7xE1XoTdB0nTusAZ2wK1IVqb+9+Oficmne+2WA9HPPmV3nyYf
        GhhhdwC9+JmGQN6Hqsgw9lgHOjdGtCk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-vsIlHttSNjmCsLeZy7WREQ-1; Wed, 30 Nov 2022 01:54:47 -0500
X-MC-Unique: vsIlHttSNjmCsLeZy7WREQ-1
Received: by mail-io1-f70.google.com with SMTP id t2-20020a6b6402000000b006dea34ad528so10520354iog.1
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKIPeexGrBZvrEr+XXCg6jGzD5iE9g+Y7DE5GJYcBvQ=;
        b=3Iq6MDXCENmy+taiguJMTtuk4XJrzjATwZiuS4bT90FWG13Wvepkfo5jfqsT/Jm1P1
         JLg38xrAP7eyEyJtPJ3Vzm+lHQBx6nnyTDmAUKT9S7mVgJUEm98ewDpLjmiunZ2OT0jw
         vStjzZvBJpLrlWzWvfAtYhXzRr1kvVuCsSQoPC/FDNSljHILpsBg/Jlybe0tgZxcK5xA
         X/Z7bzohwlOM84VahgXeYeMlY+nIA2HEE4aId0xRnTxVFjuyk7aHu49INFdOVCk0pAOM
         1KLVKf6tMJLeVMewAO1ThF8IsBdMjofgPgMSK4nC+VuBDGSqIEpozoZXr9SawSPk9Xyv
         k9lQ==
X-Gm-Message-State: ANoB5pmvS6o0CMlQ+GZGveEFfCMBKT85ESSDr5O9ej1IJr2JoO+Uz/1T
        e5FUoDPWXgJHqEG/GjakQhUdLwiKgYyAcTwTSU3PUlr56viAuDu36XJkoVrZKjT1cwvpnqWZV1Q
        S3M3Z0ip87iS3ncmDO7DVEyo56qEBf7Dvv6i04A==
X-Received: by 2002:a02:3f55:0:b0:375:7c56:6d84 with SMTP id c21-20020a023f55000000b003757c566d84mr18341049jaf.320.1669791286440;
        Tue, 29 Nov 2022 22:54:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6vfxPItanTef9VKEwqKJRKB63fNTREeGzEnAdndw386KBgRRMWCq+0yPGCy1nFbEkL7Z2du29ZnPYX74OT02I=
X-Received: by 2002:a02:3f55:0:b0:375:7c56:6d84 with SMTP id
 c21-20020a023f55000000b003757c566d84mr18341035jaf.320.1669791285962; Tue, 29
 Nov 2022 22:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20221129103949.19737-1-lhenriques@suse.de> <4914a195-edc0-747b-6598-9ac9868593a1@redhat.com>
 <CAOi1vP8raoFP2dsc6RY1fONCsHh5FYv2xifFY7pHXZWX=-vePw@mail.gmail.com>
 <20e0674a-4e51-a352-9ce2-d939cd4f3725@redhat.com> <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
In-Reply-To: <CAOi1vP_H8jE4ZU4a4srhQev3odECgZD1LyxA8dv+Fk-bVDvoyQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 29 Nov 2022 22:54:38 -0800
Message-ID: <CAJ4mKGb=_CWTh5rrAFiib66-S6WeT=ajjkN_pOAac4d8uC9fDQ@mail.gmail.com>
Subject: Re: [PATCH v4] ceph: mark directory as non-complete complete after
 loading key
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Venky Shankar <vshankar@redhat.com>,
        =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 7:21 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Nov 29, 2022 at 3:50 PM Xiubo Li <xiubli@redhat.com> wrote:
> >
> >
> > On 29/11/2022 22:32, Ilya Dryomov wrote:
> > > On Tue, Nov 29, 2022 at 3:15 PM Xiubo Li <xiubli@redhat.com> wrote:
> > >>
> > >> On 29/11/2022 18:39, Lu=C3=ADs Henriques wrote:
> > >>> When setting a directory's crypt context, ceph_dir_clear_complete()=
 needs to
> > >>> be called otherwise if it was complete before, any existing (old) d=
entry will
> > >>> still be valid.
> > >>>
> > >>> This patch adds a wrapper around __fscrypt_prepare_readdir() which =
will
> > >>> ensure a directory is marked as non-complete if key status changes.
> > >>>
> > >>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > >>> ---
> > >>> Hi Xiubo,
> > >>>
> > >>> Here's a rebase of this patch.  I did some testing but since this b=
ranch
> > >>> doesn't really have full fscrypt support, I couldn't even reproduce=
 the
> > >>> bug.  So, my testing was limited.
> > >> I'm planing not to update the wip-fscrypt branch any more, except th=
e IO
> > >> path related fixes, which may introduce potential bugs each time as =
before.
> > >>
> > >> Since the qa tests PR has finished and the tests have passed, so we =
are
> > >> planing to merge the first none IO part, around 27 patches. And then
> > >> pull the reset patches from wip-fscrypt branch.
> > > I'm not sure if merging metadata and I/O path patches separately
> > > makes sense.  What would a user do with just filename encryption?
> >
> > Hi Ilya,
> >
> > I think the IO ones should be followed soon.
> >
> > Currently the filename ones have been well testes. And the contents wil=
l
> > be by passed for now.
> >
> > Since this is just for Dev Preview feature IMO it should be okay (?)
>
> I don't think there is such a thing as a Dev Preview feature when it
> comes to the mainline kernel, particularly in the area of filesystems
> and storage.  It should be ready for users at least to some extent.  So
> my question stands: what would a user do with just filename encryption?

I think how this merges is up to you guys and the kernel practices.
Merging only the filename encryption is definitely of *limited*
utility, but I don't think it's totally pointless -- the data versus
metadata paths are different and you are protecting against somewhat
different vulnerabilities and threat models with them. For instance,
MDS logs dump filenames, but OSD logs do not dump object data. There's
some obvious utility there even if you basically trust your provider,
or run your own cluster but want to be more secure about sending logs
via ceph-post-file.
-Greg

>
> Thanks,
>
>                 Ilya
>

