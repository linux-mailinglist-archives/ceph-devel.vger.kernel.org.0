Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041E48BF4E
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jan 2022 08:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351275AbiALHzB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 02:55:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351267AbiALHzA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 02:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641974100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mS1dC/gi/R0fGoIf1VDIJL51oaPMvxjHUGRK4zYNGvw=;
        b=fw4Ib0VwIM+5ZVD6nrzi0Rjnb6Z6+yDxMwiH3NJ9pEAMpC58z4UgoOxXCvpTBSky60e8tE
        5Wr4hO2EHjohI/aL1ToeffNSoN7R3XDGKIgasoN1BRxNXwESu4XVzF9DxC7sAIw7gs2pG8
        wisG7X/H41MlBNmV/VQHHZMqT71LQIA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-wrmOnNsIOVGqsMAzEeSMqg-1; Wed, 12 Jan 2022 02:54:59 -0500
X-MC-Unique: wrmOnNsIOVGqsMAzEeSMqg-1
Received: by mail-ed1-f70.google.com with SMTP id j10-20020a05640211ca00b003ff0e234fdfso1571749edw.0
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 23:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mS1dC/gi/R0fGoIf1VDIJL51oaPMvxjHUGRK4zYNGvw=;
        b=0RlkzPyrH7asFspMV86Yi2Pz2YVSMCRsQmLuKSEe1kBCnfLKAXNV+W5mMkZ+f5SwC6
         Rv06Ku/pLnS2OutPV1DfGf4hmcEbP+up0T5KpfMBHuQ08wdLFuFE32fWKAeo0kYPLghR
         Hb17/gQNCoUhjsLqlw80y/4RSz85CWLPwUiVXj3DO+WXEOjWrqaxwMIAswynmppoyr39
         mIlLRe5hEkTh+JTRqbt5WWHfeRbesWOpGMKr/+t8rG7jaJgOERzB7+IoT8pIphBrcIbc
         foo7N2NkwUAProLeot6byPaq4F+je3isFcGoFW5HxBCNGKjvjPokPsJxXyr7TsSNTv3W
         Dsog==
X-Gm-Message-State: AOAM53107J20pUwH2ycm+7PLa+BJpqrUcWJCnoY2ZryLENw5Keu+J48g
        O/bCdDx0pPOzMxSWGIsxGK7W3YB071htwv2LHqHAISyU+lV8zAAfByWZpqLtH1f7x6+PwYpvBIt
        6N+M3PoprCeFZ4tWmZ8KTMJkIwMD6QMK5Q/u/vA==
X-Received: by 2002:a50:ed95:: with SMTP id h21mr219489edr.208.1641974097427;
        Tue, 11 Jan 2022 23:54:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9V/OZ0SPazv8oExyWW7Fh2dH95pEK13ePOqfX6CA9HPaIbGHCU2UWxAIhp5xjF0PAHJA5DayTXM69FvnIDi4=
X-Received: by 2002:a50:ed95:: with SMTP id h21mr219479edr.208.1641974097213;
 Tue, 11 Jan 2022 23:54:57 -0800 (PST)
MIME-Version: 1.0
References: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn>
In-Reply-To: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 12 Jan 2022 13:24:20 +0530
Message-ID: <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
Subject: Re: dmesg: mdsc_handle_reply got x on session mds1 not mds0
To:     =?UTF-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>,
        Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

+Greg

On Mon, Jan 10, 2022 at 12:08 AM =E8=83=A1=E7=8E=AE=E6=96=87 <sehuww@mail.s=
cut.edu.cn> wrote:
>
> Hi ceph developers,
>
> Today we got one of our OSD hosts hang on OOM. Some OSDs were flapping an=
d eventually went down and out. The recovery caused one OSD to go full, whi=
ch is used in both cephfs metadata and data pools.
>
> The strange thing is:
> * Many of our users report unexpected =E2=80=9CPermission denied=E2=80=9D=
 error when creating new files

That's weird. I would expect the operation to block in the worst case.

> * dmesg has some strange error (see examples below). During that time, no=
 special logs on both active MDSes.
> * The above two strange things happens BEFORE the OSD got full.
>
> Jan 09 01:27:13 gpu027 kernel: libceph: osd9 up
> Jan 09 01:27:13 gpu027 kernel: libceph: osd10 up
> Jan 09 01:28:55 gpu027 kernel: libceph: osd9 down
> Jan 09 01:28:55 gpu027 kernel: libceph: osd10 down
> Jan 09 01:32:35 gpu027 kernel: libceph: osd6 weight 0x0 (out)
> Jan 09 01:32:35 gpu027 kernel: libceph: osd16 weight 0x0 (out)
> Jan 09 01:34:18 gpu027 kernel: libceph: osd1 weight 0x0 (out)
> Jan 09 01:39:20 gpu027 kernel: libceph: osd9 weight 0x0 (out)
> Jan 09 01:39:20 gpu027 kernel: libceph: osd10 weight 0x0 (out)
> Jan 09 01:53:07 gpu027 kernel: ceph: mdsc_handle_reply got 30408991 on se=
ssion mds1 not mds0
> Jan 09 01:53:14 gpu027 kernel: ceph: mdsc_handle_reply got 30409829 on se=
ssion mds1 not mds0
> Jan 09 01:53:15 gpu027 kernel: ceph: mdsc_handle_reply got 30409925 on se=
ssion mds1 not mds0
> Jan 09 01:53:28 gpu027 kernel: ceph: mdsc_handle_reply got 30411416 on se=
ssion mds1 not mds0
> Jan 09 02:05:07 gpu027 kernel: ceph: mdsc_handle_reply got 30417742 on se=
ssion mds0 not mds1
> Jan 09 02:48:52 gpu027 kernel: ceph: mdsc_handle_reply got 30449177 on se=
ssion mds1 not mds0
> Jan 09 02:49:17 gpu027 kernel: ceph: mdsc_handle_reply got 30452750 on se=
ssion mds1 not mds0
>
> After reading the code, the replies are unexpected and just dropped. Any =
ideas about how this could happen? And is there anything I need to worry ab=
out? (The cluster is now recovered and looks good)

The MDS should ask the client to "forward" the operation to another
MDS if it is not the auth for an inode.

It would be interesting to see what "mds1" was doing around the
"01:53:07" timestamp. Could you gather that from the mds log?

>
> The clients are Ubuntu 20.04 with kernel 5.11.0-43-generic. Ceph version =
is 16.2.7. No active MDS restarts during that time. Standby-replay MDSes di=
d restart, which should be fixed by my PR https://github.com/ceph/ceph/pull=
/44501 . But I don=E2=80=99t know if it is related to the issue here.
>
> Regards,
> Weiwen Hu



--=20
Cheers,
Venky

