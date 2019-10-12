Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7EAD5194
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2019 20:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfJLSVD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 12 Oct 2019 14:21:03 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:34721 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbfJLSVD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 12 Oct 2019 14:21:03 -0400
Received: by mail-qt1-f180.google.com with SMTP id 3so18939788qta.1
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2019 11:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7x2IqIp9YOj/8k0HMsKHP0zJmic7ohqvB6CM+lSrt+I=;
        b=OWE+F2w/oVRdDDfuya6sZ/1g9J6/gMg5m3MbhFgRSBO7tnJ8iUI0I78gnQvldIXKdb
         RM1aGONKt/Vfq3CV9/CGb2RrpYMZLgnOuJZJ3YZuGbk1sMyUtbqwzHkrGrj2NpvKRtoP
         9PjOynViruFTaE8EcRq0jFVJ+DOOB9qqzesqV4TOq9GFKda7Wi/eWlVzTpkcSFlShotW
         3rLGACXWObK4YRkEBYRuAEB6q2dp38xtoO1/nvQkFA1AEBeOSRWLiH3LjR81YdA08y/2
         w4LUdIK3Rgu3iPilMzFQRGftJtzJc1ujEUmxFkuU1zQfgaIgtwwR/kNaw8BUAhFhNVEw
         k1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7x2IqIp9YOj/8k0HMsKHP0zJmic7ohqvB6CM+lSrt+I=;
        b=Z3z3YY6LyQuWgmoA94EcGW5RzBkd+8z7NgcfeCMRnoY/s7GKlvW6Lpc/5hnM/t5oIT
         KdpcGst+es63ylmVVj7ZRORJ6eAptTd47Ih56dxBmn4DCfTqorFqvcIwE5hFJL+KH9rd
         6/PCv4E5L2fc2eIgfYghRatsNGkudSt7z8Wga1O5yFhczdJHyuZMkQ7Bf1rjIX7zTxkJ
         LF4OA+3BKe/yb9ltGfExF/sqDhGytfgsupGmwPOfC8TQNoS+Kx9f9W4qpZuHYchKstSd
         WrsKZeA4rGJkedf+0AwBRIbhxraCs+ZaVUpIfVAO3DInRT/CwzK4NORu0P83rEFqj6RS
         m5Mg==
X-Gm-Message-State: APjAAAUP//MMsv4l0OApgSQcNmcClfTv+dKnNQuweQLItjUXt7vJMaja
        8JX2kvSghm3ztPjD2BBZxGQZhanBAljS2x6aeWzsZTcBU+wArQ==
X-Google-Smtp-Source: APXvYqzt/1PbLRorbdBHmQrq9WRilS754zF3jFvp1wwgZtdKloQZfscug2+vsvMjYwKBPqv0Wm22sP2+qADog02cH/E=
X-Received: by 2002:ac8:22b6:: with SMTP id f51mr23505688qta.210.1570904460653;
 Sat, 12 Oct 2019 11:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpQuOjeGkD_+0LNTeLystCKJ6WqA7A3X4vNgu8n+L8KWw@mail.gmail.com>
 <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
In-Reply-To: <e9890c9feabe863dacf702327fd219f3a76fac57.camel@kernel.org>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Sat, 12 Oct 2019 11:20:49 -0700
Message-ID: <CAANLjFpvyTiSanWVOdHvaLjP_oqyPikKeDJ9oMqUq=1SS7GX-w@mail.gmail.com>
Subject: Re: Hung CephFS client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 5:47 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> What kernel version is this? Do you happen to have a more readable stack
> trace? Did this come from a hung task warning in the kernel?

$ uname -a
Linux sun-gpu225 4.4.0-142-generic #168~14.04.1-Ubuntu SMP Sat Jan 19
11:26:28 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

This was the best stack trace we could get. /proc was not helpful:
root@sun-gpu225:/proc/77292# cat stack



[<ffffffffffffffff>] 0xffffffffffffffff

We did not get messages of hung tasks from the kernel. This container
was running for 9 days when the jobs should have completed in a matter
of hours. They were not able to stop the container, but it still was
using CPU. So it smells like uninterruptable sleep, but still using
CPU which based on the trace looks like it's stuck in spinlock.

Do you want me to get something more specific? Just tell me how.

> From this, it looks like it's stuck waiting on a spinlock, but it's
> rather hard to tell for sure.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
