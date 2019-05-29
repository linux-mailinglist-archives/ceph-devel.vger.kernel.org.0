Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C20E2E754
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfE2VUk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 17:20:40 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:45255 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfE2VUj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 17:20:39 -0400
Received: by mail-ot1-f51.google.com with SMTP id t24so3514310otl.12
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 14:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NFCq8rW5kHbc7O8GLzFblZ3UfyxKCkLGOshV0n0WVtw=;
        b=DQNIAjbRt8al31J++eNceKSm0f/VpNb7lAAOs7p84iBt1H5UMSfbtytq8pWvhL+F3g
         cdRAjA8oz2KA2SFSQJQ/ijTv6PU0Tbk7hPgJpit/7IE751Q4U/OqEDbOOnKVWEwJ1lI/
         XJk+wYRCXOOOR3QRCMBBbd1FeCWY8paHeIhlcbNaJ6IB9uOvFB2Lca4a+xT5MqpsDqSg
         VdQ9v3GVS81BfXrqJikgZCo3JnjS5RghkTim036AjfZgfL6QVxZZxjCfmCmnm+y11XBG
         +8sF6xl0psXl/u2K+w+3FdW382IdPrUZsCKmyKGU+Ing8ZTjl7FgD2RnSAfdg3VWBnRG
         o38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NFCq8rW5kHbc7O8GLzFblZ3UfyxKCkLGOshV0n0WVtw=;
        b=I2L6Ou9eqK5oJXMnED5et3cIjs5qULJq64QF5RIfMjvWZbwn11CEswrpVjmRhHNUCG
         BXQl95uqwNLGsv05RSQx/Hhmm3jjWQuwhs/uGSLEwxtnYbda3T+foskUHGyt7nRKQA0Z
         S28hLICT+8xOb32h5k3xA9sRFanFZjl+BjMzPxQei2+NVDCVanoNlABe3ZSM3vvBSGFh
         Aoi+9EzeuCVyLvDUL7mvAfHS/FBM9x6Se9Ocbfu+JCZBxWOIpQuFe+31MIVWrsGKHOCp
         MtAPpLdtilIKPY49wpeU7hYwxiSfC85O8h1RADUxoaBNa+zgq8bMTcs6PNpK0+C5e1+v
         3B6w==
X-Gm-Message-State: APjAAAVdfpu+Frtoc3UV9o+kAUq88u/nGQJBF7YAeEvYb7nywbZ+QgNA
        W4lgOwRjI7jOM058CptmAIVZ6f9oM2I=
X-Google-Smtp-Source: APXvYqxwc+zr8OzxI6EzGUkU75Tlw6eyLn3dP0YC6CjHhgc+HpjQQRiXvufpq7yfu1C5rDSYPmDVjA==
X-Received: by 2002:a9d:6481:: with SMTP id g1mr4420343otl.138.1559164838901;
        Wed, 29 May 2019 14:20:38 -0700 (PDT)
Received: from [192.168.50.240] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id f137sm270982oib.27.2019.05.29.14.20.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 14:20:38 -0700 (PDT)
Subject: Re: messenger: performance drop, v2 vs v1
To:     Gregory Farnum <gfarnum@redhat.com>,
        Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
References: <e201d78b90c3fa4c794787685520cedd@suse.de>
 <CAJ4mKGadbN7ftnMJ5sDHhNt+VzWorL=xL5RCYE8=8CwaBLNSGA@mail.gmail.com>
From:   Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <ba7a92af-64fa-f160-6a16-340aee6164a5@gmail.com>
Date:   Wed, 29 May 2019 16:20:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGadbN7ftnMJ5sDHhNt+VzWorL=xL5RCYE8=8CwaBLNSGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 5/29/19 3:41 PM, Gregory Farnum wrote:
> On Wed, May 29, 2019 at 12:36 PM Roman Penyaev <rpenyaev@suse.de> wrote:
>>
>> Hi all,
>>
>> I did a quick protocol performance comparison using fio_ceph_messenger
>> engine having `37c70bd1a75f ("Merge pull request #28099 from
>> tchaikov/wip-blobhash")`
>> as a master.  I use default fio job and config:
>>
>>     src/test/fio/ceph-messenger.fio
>>
>>        iodepth=128
>>
>>     src/test/fio/ceph-messenger.conf
>>
>>        [global]
>>        ms_type=async+posix
>>        ms_crc_data=false
>>        ms_crc_header=false
>>        ms_dispatch_throttle_bytes=0
>>        debug_ms=0/0
>>
>>
>> Results:
>>
>>     protocol v1:
>>
>>       4k  IOPS=116k, BW=454MiB/s, Lat=1100.75usec
>>       8k  IOPS=104k, BW=816MiB/s, Lat=1224.83usec
>>      16k  IOPS=93.7k, BW=1463MiB/s, Lat=1366.15usec
>>      32k  IOPS=81.5k, BW=2548MiB/s, Lat=1568.80usec
>>      64k  IOPS=69.8k, BW=4366MiB/s, Lat=1831.76usec
>>     128k  IOPS=47.8k, BW=5973MiB/s, Lat=2677.71usec
>>     256k  IOPS=23.7k, BW=5917MiB/s, Lat=5406.42usec
>>     512k  IOPS=11.8k, BW=5912MiB/s, Lat=10823.24usec
>>       1m  IOPS=5792, BW=5793MiB/s, Lat=22092.82usec
>>
>>
>>     protocol v2:
>>
>>       4k  IOPS=95.5k, BW=373MiB/s, Lat=1340.09usec
>>       8k  IOPS=85.3k, BW=666MiB/s, Lat=1499.54usec
>>      16k  IOPS=75.8k, BW=1184MiB/s, Lat=1688.65usec
>>      32k  IOPS=61.6k, BW=1924MiB/s, Lat=2078.29usec
>>      64k  IOPS=53.6k, BW=3349MiB/s, Lat=2388.17usec
>>     128k  IOPS=32.5k, BW=4059MiB/s, Lat=3940.99usec
>>     256k  IOPS=17.5k, BW=4376MiB/s, Lat=7310.90usec
>>     512k  IOPS=8718, BW=4359MiB/s, Lat=14679.53usec
>>       1m  IOPS=3785, BW=3785MiB/s, Lat=33811.59usec
>>
>>
>>      IOPS percentage change:
>>
>>             v1                v2            % change
>>
>>       4k  IOPS=116k        IOPS=95.5k         -17%
>>       8k  IOPS=104k        IOPS=85.3k         -17%
>>      16k  IOPS=93.7k       IOPS=75.8k         -19%
>>      32k  IOPS=81.5k       IOPS=61.6k         -24%
>>      64k  IOPS=69.8k       IOPS=53.6k         -23%
>>     128k  IOPS=47.8k       IOPS=32.5k         -32%
>>     256k  IOPS=23.7k       IOPS=17.5k         -26%
>>     512k  IOPS=11.8k       IOPS=8718          -25%
>>       1m  IOPS=5792        IOPS=3785          -35%
>>
>>
>> Is that expected? Does anyone have similar numbers?
> 
> I don't think it's expected, and it looks like those config options
> *should* have done as expected, but maybe run with some debug logs and
> make sure the ProtocolV2 isn't doing CRCs or something after all.

Sage mentioned at Cephalocon he was a bit nervous that we might see some 
regression but I don't recall what the reasoning was.  A perf or 
wallclock profile would tell us pretty quick if it's CRC.  The fact that 
it's worse with large IOs vs small IOs might be a clue.

> 
>>
>>
>> PS. Am I mistaken or 'ms_msgr2_encrypt_messages' and
>>       'ms_msgr2_sign_messages' options are not used at all?
> 
> Hmm yeah, those should get removed (...or maybe implemented for this
> fio stuff). They're replaced by ms_cluster_mode et al when running in
> a cluster. (The defaults in master are "crc secure" for most stuff
> communications but "secure crc" for anything involving the monitors.)
> -Greg
> 
