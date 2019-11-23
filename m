Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975E6107F20
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Nov 2019 16:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKWPrC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 23 Nov 2019 10:47:02 -0500
Received: from mail-ed1-f51.google.com ([209.85.208.51]:38426 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKWPrC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 23 Nov 2019 10:47:02 -0500
Received: by mail-ed1-f51.google.com with SMTP id s10so8619072edi.5
        for <ceph-devel@vger.kernel.org>; Sat, 23 Nov 2019 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3y72wSfv8Cqiy8udK9YvlmWWaJA6XZIN7nokEYjsGd4=;
        b=al03v/q6Ne7SjU1IJKH+mxy2ffXTZCYHDEe+KEo9aBoo24kAYBv8QW9jXp2zjR2ebr
         VbWYMQ1K0bSIwC4WQJvhcNDws2ut7CrAeqfSTFu1Xn5Lxse0D6UQcF64c2iq+KYaXHHd
         lfEXl/cpKqKao2pjT8Yy9LqGC+fp+medf7DGqMA8O9TXTLoWq6NAaOJxRqg3B6yAV01W
         a0qXrPsjTuIcIXsg1q4GKJg5L+qkL7Bq0Ra6OmH5j6gswMCsv3BOypqnHl0Gl6rNQ6OU
         bUSxZIpu1fmy1eeEC9Jv/kDnjVWC/V0N8lf9Gc8R8mOeMcSBYTcqmy7w+t2Tc2Ne97qd
         G9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3y72wSfv8Cqiy8udK9YvlmWWaJA6XZIN7nokEYjsGd4=;
        b=AQFthUP+J9a1LoqEMGeBCIbKNDOZFag/5L2rZWrd2JUweu5z8KhBGOuu05Y3U4PQHa
         M6XcPCEtqZoZFHwZ/cW4i4Pnl6KjJsr8Qyf5cTrFa+FGClDqvD7EuAoDk9Bb/a1XE3M1
         wq0oYqlx+msuthVud47sv1mPEXjh/ZNKGaf5ToAHXQChdyb9xLgs5lbnFxj4xRffT4hO
         l1iZtv+qj94e3DNyTcbOXAIs6H3K9nhO/xCDVsuXvfguq+nAZ0eugy7va0QKg5AwsVvH
         wUjs5iqJAlu2zmuPvgihd2u32U6x6N0bMCL6aFdSd3w89r8bK04NTOo2VNmvXJOuHWv5
         ixTQ==
X-Gm-Message-State: APjAAAVkuzcK5bOXLWxR1ofEYhZkAbJhY6FaSPp8zntrSdg7aMAYVl/l
        rKRkfbyCfPYTR+/neBY6jg7jlTC/fBwRlF1mW6pzDQ==
X-Google-Smtp-Source: APXvYqwEr7g9RkTViivt/8Dj3cxVw5BIyVLSLAk8j/oNzFDsfD9WQL+ggDHQrteEFdmN0C6NmrbgMujaC3muil93Bhc=
X-Received: by 2002:a05:6402:168b:: with SMTP id a11mr7767954edv.107.1574524019079;
 Sat, 23 Nov 2019 07:46:59 -0800 (PST)
MIME-Version: 1.0
References: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
 <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
From:   Paul Emmerich <paul.emmerich@croit.io>
Date:   Sat, 23 Nov 2019 16:46:47 +0100
Message-ID: <CAD9yTbHfbZoC+sWuH8n3j6HTAUjKgPggL9OPGZ5FTOkz5QC0BQ@mail.gmail.com>
Subject: Re: device class : nvme
To:     Sage Weil <sage@newdream.net>
Cc:     Muhammad Ahmad <muhammad.ahmad@seagate.com>, dev@ceph.io,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 11:25 PM Sage Weil <sage@newdream.net> wrote:
> way was because I deployed bluestore *very* early on (with ceph-disk) and
> the is_nvme() detection helper doesn't work with LVM.  That's my theory at
> least.. can anybody with bluestore on NVMe devices confirm?  Does anybody
> see class 'nvme' devices in their cluster?

nope, never saw any disks automatically detected as "nvme". However,
lots of users set the device class explicitly for NVMe disks (we do
ask about the device class in our UI when creating OSDs, the default
being 'auto detect')


Paul

>
> Thanks!
> sage
>
