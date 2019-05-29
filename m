Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA22E65A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 22:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2Umd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 16:42:33 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46127 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfE2Umd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 16:42:33 -0400
Received: by mail-lf1-f52.google.com with SMTP id l26so3170353lfh.13
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 13:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FF3pZ6A2Dws0fsPY+5B36f9C+G2Seh067ifvx6o621Q=;
        b=f4IiRjGiLM8ycH9frqPmgGmWOrtVHJAAw/whKO5Jpw+rQyGsChgf9MrP0/FxGia+5f
         cBNNbIZSU7K2enjjzlTYdni5Bw2xWzZ8HSwKpCVt37FnljafDqottKpTe9yiesd2JXrf
         jIWwsxW9C8e8eleh28/S9b6CCOLkryRky9h+Ze9M2n6rqImh88q2YzmdsLgWFRPAef9b
         Qm7fXxrRu3DyCn3emXPRYTKNA9PyQJdT2uBrMIfC5pe94/gjLElGJ8qCKVGhgNucHJ8K
         KNlc2lx4aBANjJwVImUAyRWSASgglk0D7/6rS0zE5sbYOUe9Bqjgrh5CObhlQscaHxmw
         h1gg==
X-Gm-Message-State: APjAAAXe7+llaW59S5ErjI1jutBdD880iQnfE00mrRymUo+9M1R67VNk
        eGzpEY6BVgGjugvIImaKhXx2zMPtPaNNqR9ibzMMgwX6d1g=
X-Google-Smtp-Source: APXvYqwpzwHOpyt5xFX42PZhNgiVHjefDllUd6Uqz3vs7w1P0/pQXG0VycPHLmr5e6JRFreT/AqCbBQEAq8BBSYO9R4=
X-Received: by 2002:a19:ee12:: with SMTP id g18mr22075660lfb.58.1559162550698;
 Wed, 29 May 2019 13:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <e201d78b90c3fa4c794787685520cedd@suse.de>
In-Reply-To: <e201d78b90c3fa4c794787685520cedd@suse.de>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 29 May 2019 13:41:51 -0700
Message-ID: <CAJ4mKGadbN7ftnMJ5sDHhNt+VzWorL=xL5RCYE8=8CwaBLNSGA@mail.gmail.com>
Subject: Re: messenger: performance drop, v2 vs v1
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 29, 2019 at 12:36 PM Roman Penyaev <rpenyaev@suse.de> wrote:
>
> Hi all,
>
> I did a quick protocol performance comparison using fio_ceph_messenger
> engine having `37c70bd1a75f ("Merge pull request #28099 from
> tchaikov/wip-blobhash")`
> as a master.  I use default fio job and config:
>
>    src/test/fio/ceph-messenger.fio
>
>       iodepth=128
>
>    src/test/fio/ceph-messenger.conf
>
>       [global]
>       ms_type=async+posix
>       ms_crc_data=false
>       ms_crc_header=false
>       ms_dispatch_throttle_bytes=0
>       debug_ms=0/0
>
>
> Results:
>
>    protocol v1:
>
>      4k  IOPS=116k, BW=454MiB/s, Lat=1100.75usec
>      8k  IOPS=104k, BW=816MiB/s, Lat=1224.83usec
>     16k  IOPS=93.7k, BW=1463MiB/s, Lat=1366.15usec
>     32k  IOPS=81.5k, BW=2548MiB/s, Lat=1568.80usec
>     64k  IOPS=69.8k, BW=4366MiB/s, Lat=1831.76usec
>    128k  IOPS=47.8k, BW=5973MiB/s, Lat=2677.71usec
>    256k  IOPS=23.7k, BW=5917MiB/s, Lat=5406.42usec
>    512k  IOPS=11.8k, BW=5912MiB/s, Lat=10823.24usec
>      1m  IOPS=5792, BW=5793MiB/s, Lat=22092.82usec
>
>
>    protocol v2:
>
>      4k  IOPS=95.5k, BW=373MiB/s, Lat=1340.09usec
>      8k  IOPS=85.3k, BW=666MiB/s, Lat=1499.54usec
>     16k  IOPS=75.8k, BW=1184MiB/s, Lat=1688.65usec
>     32k  IOPS=61.6k, BW=1924MiB/s, Lat=2078.29usec
>     64k  IOPS=53.6k, BW=3349MiB/s, Lat=2388.17usec
>    128k  IOPS=32.5k, BW=4059MiB/s, Lat=3940.99usec
>    256k  IOPS=17.5k, BW=4376MiB/s, Lat=7310.90usec
>    512k  IOPS=8718, BW=4359MiB/s, Lat=14679.53usec
>      1m  IOPS=3785, BW=3785MiB/s, Lat=33811.59usec
>
>
>     IOPS percentage change:
>
>            v1                v2            % change
>
>      4k  IOPS=116k        IOPS=95.5k         -17%
>      8k  IOPS=104k        IOPS=85.3k         -17%
>     16k  IOPS=93.7k       IOPS=75.8k         -19%
>     32k  IOPS=81.5k       IOPS=61.6k         -24%
>     64k  IOPS=69.8k       IOPS=53.6k         -23%
>    128k  IOPS=47.8k       IOPS=32.5k         -32%
>    256k  IOPS=23.7k       IOPS=17.5k         -26%
>    512k  IOPS=11.8k       IOPS=8718          -25%
>      1m  IOPS=5792        IOPS=3785          -35%
>
>
> Is that expected? Does anyone have similar numbers?

I don't think it's expected, and it looks like those config options
*should* have done as expected, but maybe run with some debug logs and
make sure the ProtocolV2 isn't doing CRCs or something after all.

>
>
> PS. Am I mistaken or 'ms_msgr2_encrypt_messages' and
>      'ms_msgr2_sign_messages' options are not used at all?

Hmm yeah, those should get removed (...or maybe implemented for this
fio stuff). They're replaced by ms_cluster_mode et al when running in
a cluster. (The defaults in master are "crc secure" for most stuff
communications but "secure crc" for anything involving the monitors.)
-Greg
