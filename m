Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97FB14BA95
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgA1Oj7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 09:39:59 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40300 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgA1OQa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 09:16:30 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so14380191iop.7
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jan 2020 06:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wlsTiDZMPgxkZjxRWVhpxEI7aXlmDAWO0rSZGGtvDqE=;
        b=hGLtMLch0XL64+CpupnH1srjBDJ/hu0JqUMTP3WuGynmwK3H1V4A1hmnWg+MaelI8l
         K3ZIMEPTjTkdAvCPIl7XOicZGTO2hpxUhLt+fn89bS5DmHtK2TIT9dlkQWuEGWfivPW7
         67Cyyfh5ot6rDAPJsZoferap53wKUR4y3bibnU+WaK7YyTzye81JLU0ICcQNTV9og1EW
         HDSIXPD+oPxRqh73hS/oDxrHGXIH29zEYvEMwQFJ8EbOmDGw/difKa4B1NXi9MQt6ifG
         A0OKenl6qw3M/MBlmGDpznlyCGG0VIzI5arT87s6jycaYsqFcvxfnZmgspnHJ5Uxp11k
         Ef5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wlsTiDZMPgxkZjxRWVhpxEI7aXlmDAWO0rSZGGtvDqE=;
        b=n8fXhzC14Wge04OetFgJt7QLw+9vYf4Ae3fbK1EibDfz6/F0jCiweGhyGlqKDJjtAN
         wEosKHYqysJ9vk4Cmn08X/mNnBmkI9yYbMFNZzgMauan5Ejr0nV4Ve8GBZ6MeA5T6Is4
         sIAc86ykHNw+yvJ4ScyEyl47CTA/hydj8vsOVYu/5FRF1Mw12XEh5YMmttzu4m1hWB3i
         4zcx3BvXng+faG4tqQr0ZmOZzghV0hNCQ2fL+94sjTWlYwTu5qAWtk8p9tAjJbR9zgsj
         sE/TQSl92gKa9NDGOW6E4cYNIPnmnVmgIJf+OIHrWGpaHxuAHp1vL6fD2rFMux/qDeFj
         ZamA==
X-Gm-Message-State: APjAAAUhIEX/cXUso7LQYE+JjFRALB2x4C4xJtpwYvIuTXi0FB26dDXN
        qiKF0kHAp7J4xPKPw4yufksnukTDyTqhRJ1m9QQqAnw40Cw=
X-Google-Smtp-Source: APXvYqxeL8ubaUadY3oxFj4lV9WnbQq9VxPGthzcq+Oh3vSth0rXCPyvLnIEcHC18tzUwyCSBXth+8XbWDUQbuMo3as=
X-Received: by 2002:a05:6638:34c:: with SMTP id x12mr17281237jap.144.1580220989688;
 Tue, 28 Jan 2020 06:16:29 -0800 (PST)
MIME-Version: 1.0
References: <20200128130248.4266-1-xiubli@redhat.com>
In-Reply-To: <20200128130248.4266-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 28 Jan 2020 15:16:37 +0100
Message-ID: <CAOi1vP-o+mNPprtFKjD-=ifEzHS6uMva2ZDf=LM6PCT4CJuPoA@mail.gmail.com>
Subject: Re: [PATCH v5 0/10] ceph: add perf metrics support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 28, 2020 at 2:03 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Changed in V2:
> - add read/write/metadata latency metric support.
> - add and send client provided metric flags in client metadata
> - addressed the comments from Ilya and merged the 4/4 patch into 3/4.
> - addressed all the other comments in v1 series.
>
> Changed in V3:
> - addressed Jeff's comments and let's the callers do the metric
> counting.
> - with some small fixes for the read/write latency
> - tested based on the latest testing branch
>
> Changed in V4:
> - fix the lock issue
>
> Changed in V5:
> - add r_end_stamp for the osdc request
> - delete reset metric and move it to metric sysfs
> - move ceph_osdc_{read,write}pages to ceph.ko
> - use percpu counters instead for read/write/metadata latencies
>
> It will send the metrics to the MDSs every second if sending_metrics is enabled, disable as default.

Hi Xiubo,

What is this series based on?  "[PATCH v5 01/10] ceph: add caps perf
metric for each session" changes metric_show() in fs/ceph/debugfs.c,
but there is no such function upstream or in the testing branch.

Thanks,

                Ilya
