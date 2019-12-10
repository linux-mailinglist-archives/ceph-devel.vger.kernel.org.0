Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B01118A21
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfLJNry (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Dec 2019 08:47:54 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:32854 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbfLJNry (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Dec 2019 08:47:54 -0500
Received: by mail-il1-f194.google.com with SMTP id r81so16193698ilk.0
        for <ceph-devel@vger.kernel.org>; Tue, 10 Dec 2019 05:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RoE/t6CGLmiJmqMBuncfznuCDvPPaOHeHL5omMhHwkE=;
        b=TkHTX+2R4oklWeRL82yOCfMHoiCmvGi4GYStwAyeTVi1aY2mlyi6hegzZe+iWfMuMW
         sJ40FNh2rU1+i8X0cznnpQcL7s7XWMHkyNhe7r7D8xUF8W8PbB3jWH5kr4AF8k4xFaQj
         l9PWMqCIXg4rx5eB4+vRROPyuw7/N6hhzUdCcMTkNGvAfEUPwTokGsLY88kFqXrsSWTp
         dKUnGv1ZhykfLuOwnE0MSa5TWvoXa/ZrjZdpJYzSir/TGznP+U7MzQKRcJSqujrvkWGN
         mXZZckrLEiPFGO5toOF8dyAIUcGaPTATKKgH/pCGB2zjtqTEn+D47aKBMwLB1M1+sucQ
         jyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RoE/t6CGLmiJmqMBuncfznuCDvPPaOHeHL5omMhHwkE=;
        b=tO0bNdp5dTEtR6sMYj39D7QRWwdd6KjNr/6E/D+6222k4Qza31aj6sQ76WALrjsFoQ
         m4rAD8VbD7yVaaU9sRkGFyUPGNBi+KHS9ST1mjjJ8Hsx/+s/C/CCmcjNGJspIQMzljYC
         fd4DuEqQ/tZe1fdlTesIGRgqXV0lyiknG803KVmfdqviYhj+N8gWkOOMM8iBJz47J26e
         S7i8GynnM/qQItua31DcHIIs8ChP/lascFF229kRuS/u8tNcWi4ACxCdBoeA9int/XTK
         /uWdwTknxlctx8Np1uYn19DsbUS7XA3Z2HoT2oGyetU7q4/SX7GY14p6upyA+nrUUe9G
         7oVA==
X-Gm-Message-State: APjAAAWRhZQGYJ8lCl2l2kOtZ4jUd9yqJ4VdFsyN6O3HPoBtjsx0P0oJ
        KAjllDL9QSagGY8g4OEXkKyBZ2UED9bJRdurbBoMSfjBIbM=
X-Google-Smtp-Source: APXvYqzht7lY6OqfqsWB7jIO4EJ13yNSPIf2hl/OtPTw5VBeOIdyc0wdOBK0N5OszHCObGEKaLxu2+cCpfbXyP5r3RU=
X-Received: by 2002:a92:6609:: with SMTP id a9mr34850714ilc.131.1575985673622;
 Tue, 10 Dec 2019 05:47:53 -0800 (PST)
MIME-Version: 1.0
References: <87sglscy4z.fsf@suse.com>
In-Reply-To: <87sglscy4z.fsf@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Dec 2019 14:52:26 +0100
Message-ID: <CAOi1vP8JyKzsc9mxHjMZWs_SaXQD7GrNbxRic9NvChxi_dUbow@mail.gmail.com>
Subject: Re: v14.2.5 Nautilus released
To:     Abhishek Lekshmanan <abhishek@suse.com>
Cc:     ceph-announce@ceph.io, ceph-users <ceph-users@ceph.io>,
        dev@ceph.io, Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 10, 2019 at 10:45 AM Abhishek Lekshmanan <abhishek@suse.com> wrote:
>
> This is the fifth release of the Ceph Nautilus release series. Among the many
> notable changes, this release fixes a critical BlueStore bug that was introduced
> in 14.2.3. All Nautilus users are advised to upgrade to this release.
>
> For the complete changelog entry, please visit the release blog at
> https://ceph.io/releases/v14-2-5-nautilus-released/
>
> Notable Changes
> ---------------
>
> Critical fix:
>
> * This release fixes a `critical BlueStore bug <https://tracker.ceph.com/issues/42223>`_
>   introduced in 14.2.3 (and also present in 14.2.4) that can lead to data
>   corruption when a separate "WAL" device is used.
>
> New health warnings:
>
> * Ceph will now issue health warnings if daemons have recently crashed. Ceph
>   has been collecting crash reports since the initial Nautilus release, but the
>   health alerts are new. To view new crashes (or all crashes, if you've just
>   upgraded)::
>
>     ceph crash ls-new
>
>   To acknowledge a particular crash (or all crashes) and silence the health warning::
>
>     ceph crash archive <crash-id>
>     ceph crash archive-all
>
> * Ceph will now issue a health warning if a RADOS pool has a ``pg_num``
>   value that is not a power of two. This can be fixed by adjusting
>   the pool to a nearby power of two::
>
>     ceph osd pool set <pool-name> pg_num <new-pg-num>
>
>   Alternatively, the warning can be silenced with::
>
>     ceph config set global mon_warn_on_pool_pg_num_not_power_of_two false
>
> * Ceph will issue a health warning if a RADOS pool's ``size`` is set to 1
>   or, in other words, if the pool is configured with no redundancy. Ceph will
>   stop issuing the warning if the pool size is set to the minimum
>   recommended value::
>
>     ceph osd pool set <pool-name> size <num-replicas>
>
>   The warning can be silenced with::
>
>     ceph config set global mon_warn_on_pool_no_redundancy false
>
> * A health warning is now generated if the average osd heartbeat ping
>   time exceeds a configurable threshold for any of the intervals
>   computed. The OSD computes 1 minute, 5 minute and 15 minute
>   intervals with average, minimum and maximum values.  New configuration
>   option `mon_warn_on_slow_ping_ratio` specifies a percentage of
>   `osd_heartbeat_grace` to determine the threshold.  A value of zero
>   disables the warning. New configuration option `mon_warn_on_slow_ping_time`
>   specified in milliseconds over-rides the computed value, causes a warning
>   when OSD heartbeat pings take longer than the specified amount.
>   A new admin command, `ceph daemon mgr.# dump_osd_network [threshold]`, will
>   list all connections with a ping time longer than the specified threshold or
>   value determined by the config options, for the average for any of the 3 intervals.
>   Another new admin command, `ceph daemon osd.# dump_osd_network [threshold]`,
>   will do the same but only including heartbeats initiated by the specified OSD.
>
> Changes in the telemetry module:
>
> * The telemetry module now has a 'device' channel, enabled by default, that
>   will report anonymized hard disk and SSD health metrics to telemetry.ceph.com
>   in order to build and improve device failure prediction algorithms. Because
>   the content of telemetry reports has changed, you will need to re-opt-in
>   with::
>
>     ceph telemetry on
>
>   You can view exactly what information will be reported first with::
>
>     ceph telemetry show
>     ceph telemetry show device   # specifically show the device channel
>
>   If you are not comfortable sharing device metrics, you can disable that
>   channel first before re-opting-in:
>
>     ceph config set mgr mgr/telemetry/channel_crash false

This should be channel_device, right?

Thanks,

                Ilya
