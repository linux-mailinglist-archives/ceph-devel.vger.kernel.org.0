Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCAE7B8094
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Oct 2023 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242552AbjJDNRX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Oct 2023 09:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbjJDNRX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Oct 2023 09:17:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338639E
        for <ceph-devel@vger.kernel.org>; Wed,  4 Oct 2023 06:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696425389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4I2k9Hlzf8peO6A8Ym/qxBw7F78PCpZK2i+Ztob3Nno=;
        b=T1Vn10fLMZieMBw0WeDOkZbUMj/NwwegsfCpZVux6zzf8TxUish6g/qspjOPsDQ4jlcVum
        uo0K1Dz6V5RZeLjsF+RgM/NL4QT9HIRL9dqEiSZ7N6aSAkzlWUeSXkrt0WtZSY4g6fq10Y
        46Uu/zgc1M4QYr4b8eA4vtEWtZP9qpo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-CUlP9LbnOVC5Ix9FwbicPQ-1; Wed, 04 Oct 2023 09:16:27 -0400
X-MC-Unique: CUlP9LbnOVC5Ix9FwbicPQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bebfada8cso189699466b.1
        for <ceph-devel@vger.kernel.org>; Wed, 04 Oct 2023 06:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696425386; x=1697030186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4I2k9Hlzf8peO6A8Ym/qxBw7F78PCpZK2i+Ztob3Nno=;
        b=TNYlFvFDKN5D2Hpz1aJaqDc9Hz1rVCO0PXkUHBVRYmxPK809ja4mXKXhdNqC2IZcnc
         /Ka4PHSC6IFMd6ylHa28rud0ItcH3TFhEQXty0RQ1lTsDssK+c+6DEXvblm5Nd5Qs9ZM
         PVJCuY4YWuaFI8r28Ku67xfQmM1cMiia7XmeFVbkpnY2klIS8fFiYiC9sdt9ahwLDh3O
         Djw5Gy1KozZ0U+HfIS7upFK0QtoLTlzcdFvoZ1qMX1D+e6aoeomoxwSBIHv8wjP3mjgi
         UB1fEoGb6HHexm2mq+j0mBFae3t9Tcw2majj0SdQRWVUuR4QUo3anXsaws/4wNM4QcFn
         GVhg==
X-Gm-Message-State: AOJu0Yy1l4YaJwqYZ0WELSngi69eB+aXylL3IGWfBPP4HlBMxlSW5Afk
        iXhm9Oy5cojdNf2/lP1Ae0g/Qy1uom7bkVv8f0qAYS6EYWhqQJM/PiMl+MCwseH7BDeW0G6HKZg
        h+F9G6uRQeMekIEM2Z1eA3jbNddRXnQ4/oFfkVw==
X-Received: by 2002:a17:906:2253:b0:9b2:6db8:e108 with SMTP id 19-20020a170906225300b009b26db8e108mr1870488ejr.13.1696425386726;
        Wed, 04 Oct 2023 06:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV1lNyI1UoguIB3q7xGFtaDNhn2ehvHkj3VYgG7Qc8RY66GkCPHdEXu+uzYSFvUvBFB+2zWo7WSOwDWjiyKk4=
X-Received: by 2002:a17:906:2253:b0:9b2:6db8:e108 with SMTP id
 19-20020a170906225300b009b26db8e108mr1870462ejr.13.1696425386345; Wed, 04 Oct
 2023 06:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20231003110556.140317-1-vshankar@redhat.com> <CAOi1vP89eWiqUy9yZhWcSzujFre8YSnrCiNMczE_cX3QbDRsEg@mail.gmail.com>
 <CACPzV1nwAubtY2dxp88_sNNNA2DU0sOtCaSJiSoKjXcD0LHJQA@mail.gmail.com>
In-Reply-To: <CACPzV1nwAubtY2dxp88_sNNNA2DU0sOtCaSJiSoKjXcD0LHJQA@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 4 Oct 2023 18:45:49 +0530
Message-ID: <CACPzV1mWhaoPor4T8n=kX5oFjRjkbtQr5t9kZ6uCgsGciBafMA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ceph: enable async dirops by default"
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

After some digging and talking to Jeff, I figured that it's possible
to disable async dirops from the mds side by setting
`mds_client_delegate_inos_pct` config to 0:

        - name: mds_client_delegate_inos_pct
          type: uint
          level: advanced
          desc: percentage of preallocated inos to delegate to client
          default: 50
          services:
          - mds

So, I guess this patch is really not required. We can suggest this
config update to users and document it for now. We lack tests with
this config disabled, so I'll be adding the same before recommending
it out. Will keep you posted.

On Wed, Oct 4, 2023 at 10:16=E2=80=AFAM Venky Shankar <vshankar@redhat.com>=
 wrote:
>
> Hi Ilya,
>
> On Tue, Oct 3, 2023 at 5:00=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> =
wrote:
> >
> > On Tue, Oct 3, 2023 at 1:06=E2=80=AFPM Venky Shankar <vshankar@redhat.c=
om> wrote:
> > >
> > > From: Xiubo Li <xiubli@redhat.com>
> > >
> > > This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.
> > >
> > > We have identified an issue in the MDS affecting CephFS users using
> > > the kernel driver. The issue was first introduced in the octopus
> > > release that added support for clients to perform asynchronous
> > > directory operations using the `nowsync` mount option. The issue
> > > presents itself as an MDS crash resembling (any of) the following
> > > crashes:
> > >
> > >         https://tracker.ceph.com/issues/61009
> > >         https://tracker.ceph.com/issues/58489
> > >
> > > There is no apparent data loss or corruption, but since the underlyin=
g
> > > cause is related to an (operation) ordering issue, the extent of the
> > > problem could surface in other forms - most likely MDS crashes
> > > involving preallocated inodes.
> > >
> > > The fix is being reviewed and is being worked on priority:
> > >
> > >         https://github.com/ceph/ceph/pull/53752
> > >
> > > As a workaround, we recommend (kernel) clients be remounted with the
> > > `wsync` mount option which disables asynchronous directory operations
> > > (depending on the kernel version being used, the default could be
> > > `nowsync`).
> > >
> > > This change reverts the default, so, async dirops is disabled (by def=
ault).
> >
> > Hi Venky,
> >
> > Given that the fix is now up and being reviewed on priority, does it
> > still make sense to change the default?
> >
> > According to Xiubo, https://tracker.ceph.com/issues/58489 which morphed
> > into https://tracker.ceph.com/issues/61009 isn't the only concern -- he
> > also brought up https://tracker.ceph.com/issues/62810.  If the move to
> > revert (change of default) is also prompted by that issue, it should be
> > described in the patch.
>
> Fair enough -- I'll push out with an updated commit message.
>
> >
> > Thanks,
> >
> >                 Ilya
> >
>
>
> --
> Cheers,
> Venky



--=20
Cheers,
Venky

