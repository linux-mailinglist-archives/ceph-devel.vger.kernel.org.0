Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB742214D5
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jul 2020 21:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGOTEO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jul 2020 15:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOTEN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 Jul 2020 15:04:13 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF099C061755
        for <ceph-devel@vger.kernel.org>; Wed, 15 Jul 2020 12:04:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id s21so2945873ilk.5
        for <ceph-devel@vger.kernel.org>; Wed, 15 Jul 2020 12:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZLcI0zq5l35aWSO0JMxzEOm+pHYliaddoG2LH8QsM+s=;
        b=UsNoPM7pVuQHzVCXU3ghn/gsSqJZ3GzlqiikO8X+uQG27irmVfapyF/codBpT7xC6Q
         v+GjflQzRucg3DjdWM736WOyOZ84L/aUn3qg7LBY86P1HwCsaCPqUr6PL0hpbenBLT9Y
         Aual022bbPBmBSPC3RIyLRFohOc9uWredOvfd92Axb4B3NjGzUnVnU6lQwPlHjxnjSfb
         3lG1QvwfCXGLk5ut7tXPzy3gXLXVSKStCyOqYAoZrGkl/agAOia1tHT5VngQ5TZYx8Zz
         64fE0Eo9fRs7XEx1DFeUbv7kf4K21zNl6H303rXivSJBQnJkpoB9bPNd5QSuYj1hGuWH
         WlrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZLcI0zq5l35aWSO0JMxzEOm+pHYliaddoG2LH8QsM+s=;
        b=AGlK/ZUfXiSwjY4M9PvZO1Rw42alRfDliQQigCTaSc1y0/JUqOLWyUAey8M/dY7eZm
         2DccquZmmMB3YtgGMptRRwtNPvhzgcc4jZYoMmn+ChMrJbSG4P5+eaDM8VGOAkVcE2Bu
         7xyDoBX3HEos4XKjQVJf8hezH4QuuHrkmvoGLKiFRMK10J1ilmCp/vhcOfoF8Udy7TFv
         E/C08qE8ItjtdUQtrgo0Z+P4+pCJlisobkz9VZWi4H96n3pbkdO/5O8SAkdTCyvD9R2D
         uhd5bM6Qz2Q5dJRf77UaLo42ORfBLmkihu3BdiX/Au6XHfcqsxpC1ep3O5MUTMKYLZ21
         rMFg==
X-Gm-Message-State: AOAM530SNoQk1dnagAlyLpY9nYmbS8v+hgcGZ0yapWlOIv5+LOm7306R
        pfgngvLzWtUfqHLdmz15c3TctoPo6Ih33yIc7JdKJT8AM4I=
X-Google-Smtp-Source: ABdhPJyUeHs+6pGdWNLCGJhVHZY3x0v7dmi+DgLbncPt//PaUYb18sDmkYD6KJGkYWmfi6DM2lP7jvG4qYMkOn+Umd8=
X-Received: by 2002:a05:6e02:48e:: with SMTP id b14mr887157ils.143.1594839852303;
 Wed, 15 Jul 2020 12:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <CA+xD70OJhkhH=+5W7M8NM54VPh42FmbD3O0yqKe1p-+=yd9zXQ@mail.gmail.com>
 <CAOi1vP-hmzEkkUWGOwxksQn8ny1HzgNURtnf1D33KQq4-49xgQ@mail.gmail.com> <CA+xD70Neac2hpzu-Tg7s+1NCDegwzKs-zdTk8DYTWZPjNaexaA@mail.gmail.com>
In-Reply-To: <CA+xD70Neac2hpzu-Tg7s+1NCDegwzKs-zdTk8DYTWZPjNaexaA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 15 Jul 2020 21:04:15 +0200
Message-ID: <CAOi1vP9yz7hLuSRWnDtj3wdKZD1qTiF+84_o5F91bw3wZam=0g@mail.gmail.com>
Subject: Re: [Ceph-qa] multiple BLK-MQ queues for Ceph's RADOS Block Device
 (RBD) and CephFS
To:     Bobby <italienisch1987@gmail.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 15, 2020 at 12:47 AM Bobby <italienisch1987@gmail.com> wrote:
>
>
>
> Hi Ilya,
>
> Thanks for the reply. It's basically both i.e. I have a specific project =
currently and also I am looking to make ceph-fuse faster.
>
> But for now, let me ask specifically the project based question. In the p=
roject I have to write a blk-mq kernel driver for the Ceph client machine. =
The Ceph client machine will transfer the data to HBA or lets say any embed=
ded device.

What is a "Ceph client machine"?

A Ceph client (or more specifically a RADOS client) speaks RADOS
protocol and transfers data to OSD daemons.  It can't transfer data
directly to a physical device because something has to take care of
replication, ensure consistency and self healing, etc.  This is the
job of the OSD.

>
> My hope is that there can be an alternative and that alternative is to no=
t implement a blk-mq kernel driver and instead do the stuff in userspace. I=
 am trying to avoid writing a blk-mq kernel driver and yet achieve the mult=
i-queue implementation through userspace. Is it possible?
>
> Also AFAIK, the Ceph=E2=80=99s block storage implementation uses a client=
 module and this client module has two implementations librbd (user-space) =
and krbd (kernel module). I have not gone deep into these client modules. b=
ut can librbd help me with this?

I guess I don't understand the goal of your project.  A multi-queue
implementation of what exactly?  A Ceph block device, a Ceph filesystem
or something else entirely?  It would help if you were more specific
because "a multi-queue driver for Ceph" is really vague.

Thanks,

                Ilya
