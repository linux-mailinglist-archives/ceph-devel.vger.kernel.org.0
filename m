Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5466B2E59C
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 21:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfE2Tx4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 15:53:56 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:36606 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2Tx4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 15:53:56 -0400
Received: by mail-oi1-f182.google.com with SMTP id y124so3115886oiy.3
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 12:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=s1srKaFiJL8+hUPIvV7wcE1eqtlb7thwL33ZTDi/ZfA=;
        b=iQMU0ZnoNUgFWqApYDdwswLPrYB1ox2eg2HO5dG3rYoT1zptSntF6d1TM9gyE0KKQm
         PignnHerWjUwjGVhnOTeHg+OeRDEcJpQCpy+cBN6prRAMkmBD5LPqiTDS/1tbJUgUt9g
         5M14grgMzQ0GBU9ywi8RhvHu4+wjEGoPVlFPOsI0mWMEXlMz5kpBQvXRS73NvJf5mUtF
         hAVUwZJMSFn2asbxRMcufwdgxUZ6BVrvhNxGXn+5XMmzLB1819Gs37F7ZNRxv07qfOR7
         56h8Aw4FuxsCXnlFP8GEm6VURNtGh0Kij7/U9KJCm0N02p8VRGt9o+43nI6JdrZlCjOH
         Fkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1srKaFiJL8+hUPIvV7wcE1eqtlb7thwL33ZTDi/ZfA=;
        b=qiGRn8tizNEyvO7DoM4cXTgp8vxuH1iNVUekChjdmNCr1k2se0E7LtTOwJehDkqYSn
         tNJO8RIg69/G5AJeYFh+70FsKbAXS9/nmIfP88G22O7k3dDZF7Z2v0Ud99Kz6U6/fPSg
         F1MuPyn1vG0UO7JP1JWkKtOV+7ERMKyvk9AG3LAsPTrpuPO2l/JyDnB2LC43mHXF2M+l
         dtV77UyqeRvwKe1qIElnw0jRJNYMv4Qkak8jIaZrZq75vitlPuyQy2P4TorP3aKfU6uq
         G0cxmgIj+w4XFrnAozdddFCDtjbO/8Fepim6PjDl5t/hr18x10XzterA/PLE/s5GCcme
         WZyQ==
X-Gm-Message-State: APjAAAVBfxs0VL5pVxJn407zySGIwyxbbYK7huIQYs2uvzsw1zVTYX8t
        N3PQsXyMsZgHjtEFK7Fh2U+2Q8f9QGQ=
X-Google-Smtp-Source: APXvYqyM/axFjIAgtGeeI7ojEcNsT0TM39eo8xa1u8OzdI0qpHCdwJi/UnG0G6dCJXVLZ2HSAiaHjg==
X-Received: by 2002:aca:4457:: with SMTP id r84mr23118oia.42.1559159635667;
        Wed, 29 May 2019 12:53:55 -0700 (PDT)
Received: from [192.168.50.240] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id c24sm195766otm.75.2019.05.29.12.53.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 12:53:55 -0700 (PDT)
Subject: Re: messenger: performance drop, v2 vs v1
To:     Roman Penyaev <rpenyaev@suse.de>, ceph-devel@vger.kernel.org
References: <e201d78b90c3fa4c794787685520cedd@suse.de>
From:   Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <28250032-6856-15d2-f8a9-3acee7785e61@gmail.com>
Date:   Wed, 29 May 2019 14:53:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e201d78b90c3fa4c794787685520cedd@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Roman,

Have you looked at any runs yet through perf or one of our wallclock 
profilers?  Maybe the 4k and 1m cases.  If you'd like to try mine it's here:

https://github.com/markhpc/gdbpmp


Mark


On 5/29/19 2:35 PM, Roman Penyaev wrote:
> Hi all,
> 
> I did a quick protocol performance comparison using fio_ceph_messenger
> engine having `37c70bd1a75f ("Merge pull request #28099 from 
> tchaikov/wip-blobhash")`
> as a master.  I use default fio job and config:
> 
>    src/test/fio/ceph-messenger.fio
> 
>       iodepth=128
> 
>    src/test/fio/ceph-messenger.conf
> 
>       [global]
>       ms_type=async+posix
>       ms_crc_data=false
>       ms_crc_header=false
>       ms_dispatch_throttle_bytes=0
>       debug_ms=0/0
> 
> 
> Results:
> 
>    protocol v1:
> 
>      4k  IOPS=116k, BW=454MiB/s, Lat=1100.75usec
>      8k  IOPS=104k, BW=816MiB/s, Lat=1224.83usec
>     16k  IOPS=93.7k, BW=1463MiB/s, Lat=1366.15usec
>     32k  IOPS=81.5k, BW=2548MiB/s, Lat=1568.80usec
>     64k  IOPS=69.8k, BW=4366MiB/s, Lat=1831.76usec
>    128k  IOPS=47.8k, BW=5973MiB/s, Lat=2677.71usec
>    256k  IOPS=23.7k, BW=5917MiB/s, Lat=5406.42usec
>    512k  IOPS=11.8k, BW=5912MiB/s, Lat=10823.24usec
>      1m  IOPS=5792, BW=5793MiB/s, Lat=22092.82usec
> 
> 
>    protocol v2:
> 
>      4k  IOPS=95.5k, BW=373MiB/s, Lat=1340.09usec
>      8k  IOPS=85.3k, BW=666MiB/s, Lat=1499.54usec
>     16k  IOPS=75.8k, BW=1184MiB/s, Lat=1688.65usec
>     32k  IOPS=61.6k, BW=1924MiB/s, Lat=2078.29usec
>     64k  IOPS=53.6k, BW=3349MiB/s, Lat=2388.17usec
>    128k  IOPS=32.5k, BW=4059MiB/s, Lat=3940.99usec
>    256k  IOPS=17.5k, BW=4376MiB/s, Lat=7310.90usec
>    512k  IOPS=8718, BW=4359MiB/s, Lat=14679.53usec
>      1m  IOPS=3785, BW=3785MiB/s, Lat=33811.59usec
> 
> 
>     IOPS percentage change:
> 
>            v1                v2            % change
> 
>      4k  IOPS=116k        IOPS=95.5k         -17%
>      8k  IOPS=104k        IOPS=85.3k         -17%
>     16k  IOPS=93.7k       IOPS=75.8k         -19%
>     32k  IOPS=81.5k       IOPS=61.6k         -24%
>     64k  IOPS=69.8k       IOPS=53.6k         -23%
>    128k  IOPS=47.8k       IOPS=32.5k         -32%
>    256k  IOPS=23.7k       IOPS=17.5k         -26%
>    512k  IOPS=11.8k       IOPS=8718          -25%
>      1m  IOPS=5792        IOPS=3785          -35%
> 
> 
> Is that expected? Does anyone have similar numbers?
> 
> 
> PS. Am I mistaken or 'ms_msgr2_encrypt_messages' and
>      'ms_msgr2_sign_messages' options are not used at all?
> 
> -- 
> Roman
> 
