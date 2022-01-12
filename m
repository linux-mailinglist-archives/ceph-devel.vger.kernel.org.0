Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4385D48C934
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jan 2022 18:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355544AbiALRUX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 12:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355561AbiALRUH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 12:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642008007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYHe4IY5Mel744p4GdVxan6D3GX9z0pOc8eiG1+4oPM=;
        b=iTM2Y8Zg9pNqACt5vZyNaHHqKnFJPS54RiuKi8JGomkRsRv+8oLWdX38KDaYn9bXDg68gT
        ObPPFdhHLaE8VhvmXuEyYGrzZB0nBmzVl9xCX+h/RJbIdMjLjfOkm846q0V2C+XghxBv6E
        F5v8/UGycVVOq/MFpRH0nTFADpkfs74=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-XSvKV8q_MKi6bBoz7JY66Q-1; Wed, 12 Jan 2022 12:20:06 -0500
X-MC-Unique: XSvKV8q_MKi6bBoz7JY66Q-1
Received: by mail-qv1-f70.google.com with SMTP id jv3-20020a05621429e300b0041696de044bso3283277qvb.14
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jan 2022 09:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eYHe4IY5Mel744p4GdVxan6D3GX9z0pOc8eiG1+4oPM=;
        b=B5C0jqD/dpWWA7dTUZ3edfJL7D3xX4+nuaISNbAP+7HC6IQO5Vzs7aiIC6yFRoT3Ij
         wAxiqPuUMFqetMBYolVYGGDUSYLJXZTb4osnSxtmh5qyu0gNQZ8Dix0E5sr2tHXbruKC
         pviZ+2uXYsjMqGviAr0NPOlnQA4R2CKDpSRcvx6ZdPZnFTFteT6oJuMFyPkTWgodCM1B
         Uluc26opu5M8f1XYtvbpiEhjPUyUbYDEnPxMMi8YkYfd0wlY1R6pwSCQD1scJ25oq+lm
         o+5maI8y7Pm9T0HJWbG4jyv5ioSTxPxdi0OjrczH+S6FSXyBuKbDxpHiKTUzpGkKI432
         oeGQ==
X-Gm-Message-State: AOAM530/S3fklUgcUTzbQE5A0o9Wo+LnS60HGrEv9pldbTSybsiWx5ze
        Q2XvQYrjtLJjiC4comh/G44HQ9SXIt12I8W0tAlmjRp8IKrdGoaTn1Dfav1rCzp9waLOlF5CmpR
        fMzDzOhWkmasnw3f+drtudrUJdaT6iOAE7zIN3Q==
X-Received: by 2002:a05:620a:2683:: with SMTP id c3mr518878qkp.767.1642008005321;
        Wed, 12 Jan 2022 09:20:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB6dcjHC5d12Gytyn2iRVlbnL88BtQQ/065QOXFn+xoj0W5X77jRS3HzQq8xWo60frxzNEqUPMwRgPCSBJMx8=
X-Received: by 2002:a05:620a:2683:: with SMTP id c3mr518844qkp.767.1642008004863;
 Wed, 12 Jan 2022 09:20:04 -0800 (PST)
MIME-Version: 1.0
References: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn> <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
In-Reply-To: <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 12 Jan 2022 09:19:47 -0800
Message-ID: <CAJ4mKGY_Vr6OEe+aO9sXS6tAk9mVgtZga=eFbtsG3QY58KPHqQ@mail.gmail.com>
Subject: Re: dmesg: mdsc_handle_reply got x on session mds1 not mds0
To:     Venky Shankar <vshankar@redhat.com>
Cc:     =?UTF-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 11:55 PM Venky Shankar <vshankar@redhat.com> wrote:
>
> +Greg
>
> On Mon, Jan 10, 2022 at 12:08 AM =E8=83=A1=E7=8E=AE=E6=96=87 <sehuww@mail=
.scut.edu.cn> wrote:
> >
> > Hi ceph developers,
> >
> > Today we got one of our OSD hosts hang on OOM. Some OSDs were flapping =
and eventually went down and out. The recovery caused one OSD to go full, w=
hich is used in both cephfs metadata and data pools.
> >
> > The strange thing is:
> > * Many of our users report unexpected =E2=80=9CPermission denied=E2=80=
=9D error when creating new files
>
> That's weird. I would expect the operation to block in the worst case.

I think some configurations or code paths end up returning odd errors
instead of ENOSPC or EQUOTA, which is probably what the cluster was
returning.

>
> > * dmesg has some strange error (see examples below). During that time, =
no special logs on both active MDSes.
> > * The above two strange things happens BEFORE the OSD got full.
> >
> > Jan 09 01:27:13 gpu027 kernel: libceph: osd9 up
> > Jan 09 01:27:13 gpu027 kernel: libceph: osd10 up
> > Jan 09 01:28:55 gpu027 kernel: libceph: osd9 down
> > Jan 09 01:28:55 gpu027 kernel: libceph: osd10 down
> > Jan 09 01:32:35 gpu027 kernel: libceph: osd6 weight 0x0 (out)
> > Jan 09 01:32:35 gpu027 kernel: libceph: osd16 weight 0x0 (out)
> > Jan 09 01:34:18 gpu027 kernel: libceph: osd1 weight 0x0 (out)
> > Jan 09 01:39:20 gpu027 kernel: libceph: osd9 weight 0x0 (out)
> > Jan 09 01:39:20 gpu027 kernel: libceph: osd10 weight 0x0 (out)

All of these are just reports about changes in the OSDMap. It looks
like something pretty bad happened with your cluster (an OSD filling
up isn't good, but I didn't think on its own it would cause them to
get marked down+out), but this isn't a direct impact on the kernel
client or filesystem...

> > Jan 09 01:53:07 gpu027 kernel: ceph: mdsc_handle_reply got 30408991 on =
session mds1 not mds0
> > Jan 09 01:53:14 gpu027 kernel: ceph: mdsc_handle_reply got 30409829 on =
session mds1 not mds0
> > Jan 09 01:53:15 gpu027 kernel: ceph: mdsc_handle_reply got 30409925 on =
session mds1 not mds0
> > Jan 09 01:53:28 gpu027 kernel: ceph: mdsc_handle_reply got 30411416 on =
session mds1 not mds0
> > Jan 09 02:05:07 gpu027 kernel: ceph: mdsc_handle_reply got 30417742 on =
session mds0 not mds1
> > Jan 09 02:48:52 gpu027 kernel: ceph: mdsc_handle_reply got 30449177 on =
session mds1 not mds0
> > Jan 09 02:49:17 gpu027 kernel: ceph: mdsc_handle_reply got 30452750 on =
session mds1 not mds0
> >
> > After reading the code, the replies are unexpected and just dropped. An=
y ideas about how this could happen? And is there anything I need to worry =
about? (The cluster is now recovered and looks good)
>
> The MDS should ask the client to "forward" the operation to another
> MDS if it is not the auth for an inode.

Yeah. Been a while since I was in this code but I think this will
generally happen if the MDS cluster is migrating metadata and the
client for some reason hasn't kept up on the changes =E2=80=94 the
newly-responsible MDS might have gotten the request forwarded
directly, and replied to the client, but the client doesn't expect it
to be responsible for that op.
*IIRC* it all gets cleaned up when the client resubmits the operation
so this isn't an issue.
-Greg


>
> It would be interesting to see what "mds1" was doing around the
> "01:53:07" timestamp. Could you gather that from the mds log?
>
> >
> > The clients are Ubuntu 20.04 with kernel 5.11.0-43-generic. Ceph versio=
n is 16.2.7. No active MDS restarts during that time. Standby-replay MDSes =
did restart, which should be fixed by my PR https://github.com/ceph/ceph/pu=
ll/44501 . But I don=E2=80=99t know if it is related to the issue here.
> >
> > Regards,
> > Weiwen Hu
>
>
>
> --
> Cheers,
> Venky
>

