Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF624C1567
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 15:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbiBWO1J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 09:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236643AbiBWO1H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 09:27:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EA0DE0DA
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645626395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YL2ZXu4QkUG++W9vsitoHbo5MWQjwSc7ynoyGTnUsA4=;
        b=bq/PEkV4iGICSa2tkp5n0bB2M5EhZany+Ybyc+FZCAorTmgw6oNLUta9rVjrN5ARkLTD7g
        pVSrVmOiJ4J89qvkQv2fyc2gKuyxvrjhfwna36rrVNh0j+Mmw4o2vX1Oo1FLHjRLJ1NPtB
        zl6fP80GAKhZEy3uYWlz+svnUcl2nZ8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-seIV8dvjMG2WGU2HkDgMIg-1; Wed, 23 Feb 2022 09:26:34 -0500
X-MC-Unique: seIV8dvjMG2WGU2HkDgMIg-1
Received: by mail-io1-f70.google.com with SMTP id n5-20020a5e8c05000000b00640d0a712d3so7766658ioj.1
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:26:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YL2ZXu4QkUG++W9vsitoHbo5MWQjwSc7ynoyGTnUsA4=;
        b=3g1HOaqI6D5469yvDZFZfkNoa7lByvWkYWsXq8G9n9Kpj9Ja5BEMWS3ejQ0o+Zmhuo
         bCX0OJXkNqeULs/a/Bx3guaCuYQfwqWNQ3vOv5w/Sg2vvRU38Uj77FI9vpvEtEQbnEII
         EfrLnmIukbAmTSRTcZN15sO0ZqlLsqrDCdfeg62S++y3TW/ptn3WNETN+wrf5+GlYQiy
         RQ0Ix1IArkP037dcf07dw2b599Y96LmywGMIXwiy4obOhMOciBGpUdFgn9xF5jap+hob
         mWcrEH6c2Qjm3xR29K7HoS58O5uuyNPbK5FFCRWoRJw59TmveEGO58Vk6P5anDrZ7c0i
         sQEA==
X-Gm-Message-State: AOAM533OB4C1GXsZYmzLB1tRB2Cv7C1UPlOhZ0VVHZIxfUKdQwJV5vjq
        WrUWj55y7CjTcxmOkhYBrLUdph38kZ28wt5d6kcP/iYJgA6GERlLa+HvLbSD24X3lzZzIXFn6z0
        As0GnkxCA4AElr4lf2oC9/A==
X-Received: by 2002:a02:716d:0:b0:315:292f:2a2f with SMTP id n45-20020a02716d000000b00315292f2a2fmr11813jaf.188.1645626393826;
        Wed, 23 Feb 2022 06:26:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8gtjZ1DlA/Qs+EIRoIc8T1OwpjSiEaz5DUr7uJ3T9Bt7QuL8ocJDhTGDXFOD/i6SziyDcTw==
X-Received: by 2002:a02:716d:0:b0:315:292f:2a2f with SMTP id n45-20020a02716d000000b00315292f2a2fmr11783jaf.188.1645626393412;
        Wed, 23 Feb 2022 06:26:33 -0800 (PST)
Received: from [192.168.50.212] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id m11sm7153989ilg.53.2022.02.23.06.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 06:26:33 -0800 (PST)
Message-ID: <47a841af-6bcd-8e8d-d6dd-2071f435bd6f@redhat.com>
Date:   Wed, 23 Feb 2022 08:26:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Benching ceph for high speed RBD
Content-Language: en-US
To:     Bartosz Rabiega <bartosz.rabiega@ovhcloud.com>, dev <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
From:   Mark Nelson <mnelson@redhat.com>
In-Reply-To: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Bartosz,


As luck would have it, I've been running through a huge bisection sweep 
lately looking at regressions as well so can give you similar numbers 
for our AMD test cluster. I'll try to format similarly to what you've 
got below.  The biggest difference between our tests is likely that you 
are far more CPU, Memory, and PCIe limited in your tests than I am in 
mine.  You might be in some cases showing similar regression or 
different ones depending on how the test is limited.  Also, I noticed 
you don't mention run times or cluster aging.  That can also have an effect.


Hardware setup
--------------
10x backend servers
CPU: 1x AMD EPYC 7742 64-Core (64c+64t)
Storage: 6x NVMe (4TB Samsung PM983)
Network: 100gbps
OS: CentOS Stream
Kernel: 4.18.0-358.el8.x86

Server nodes also serving as clients


Software config
---------------
60 OSDs in total (6 OSDs per host)
1 OSD per NVMe drive
Each OSD runs on bare metal
4k min_alloc size_ssd (even for previous releases that used 16k)
rbd cache disabled
8GB osd_memory_target
Scrub disabled
Deep-scrub disabled
Ceph balancer off
1 pool 'rbd':
- 1024 PG
- PG autoscaler off
- 3x replication


Tests
----------------
qd - queue depth (number of IOs issued simultaneously to single RBD image)

Test environment
----------------
- 40 rbd images (default features, size 256GB)
- All the images have 64GB written before tests are done (64GB dataset per image).
- client version same as osd version
- Each node runs fio with rbd engine (librbd) against 4 rbd images (10x4 in total)
- Ceph is compiled and installed from src.
- In some cases entire tests were repeated (labeled b, c, d, etc after the verison)

IOPS tests
==========

- 4MB, 128KB, and 4KB IO Sizes.
- read(seq), write(seq), randread, randwrite test types
- Each combination of io size and test type is run in 1 Sweep
- Cluster runs 3 sweeps
- Cluster is rebuilt for every ceph release
- 300s runtime per test
- 256qd


4k randwrite	Sweep 0 IOPS	Sweep 1 IOPS	Sweep 2 IOPS	Notes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
14.0.0		496381		491794		451793		Worst
14.2.0		638907		620820		596170		Big improvement
14.2.10		624802		565738		561014
14.2.16		628949		564055		523766
14.2.17		616004		550045		507945
14.2.22		711234		654464		614117		Huge start, but degrades

15.0.0		636659		620931		583773		
15.2.15		580792		574461		569541		No longer degrades
15.2.15b	584496		577238		572176		Same

16.0.0		551112		550874		549273		Worse than octopus? (Doesn't match prior Intel tests)
16.2.0		518326		515684		523475		Regression, doesn't degrade
16.2.4		516891		519046		525918
16.2.6		585061		595001		595702		Big win, doesn't degrade
16.2.7		597822		605107		603958		Same
16.2.7b		586469		600668		599763		Same


FWIW, we've also been running single OSD performance bisections:
https://gist.github.com/markhpc/fda29821d4fd079707ec366322662819

I believe at least one of the regressions may be related to
https://github.com/ceph/ceph/pull/29674

There are other things going on in other tests (large sequential writes!) that are still being diagnosed.

Mark


On 2/23/22 05:10, Bartosz Rabiega wrote:
> Hello cephers,
>
> I've recently been doing some intensive performance benchmarks of different ceph versions.
> I'm trying to figure out perf numbers which can be achieved for high speed ceph setup for RBD (3x replica).
>  From what I can see there is a significant perf drop on 16.2.x series (4k writes).
> I can't find any clear reason for such behavior.
>
> Hardware setup
> --------------
> 3x backend servers
> CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
> Storage: 24x NVMe
> Network: 40gbps
> OS: Ubuntu Focal
> Kernel: 5.15.0-18-generic
>
> 4x client servers
> CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
> Network: 40gbps
> OS: Ubuntu Focal
> Kernel: 5.11.0-37-generic
>
> Software config
> ---------------
> 72 OSDs in total (24 OSDs per host)
> 1 OSD per NVMe drive
> Each OSD runs in LXD container
> Scrub disabled
> Deep-scrub disabled
> Ceph balancer off
> 1 pool 'rbd':
> - 1024 PG
> - PG autoscaler off
>
> Test environment
> ----------------
> - 128 rbd images (default features, size 128GB)
> - All the images are fully written before any tests are done! (4194909 objects allocated)
> - client version ceph 16.2.7 vanilla eu.ceph.com
> - Each client runs fio with rbd engine (librbd) against 32 rbd images (4x32 in total)
>
>
> Tests
> ----------------
> qd - queue depth (number of IOs issued simultaneously to single RBD image)
>
> IOPS tests
> ==========
> - random IO 4k, 4qd
> - random IO 4k, 64qd
>
> Write			4k 4qd	4k 64qd
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 14.2.16			69630	132093
> 14.2.22			97491	156288
> 15.2.14			77586	93003
> *15.2.14 – canonical	110424	168943
> 16.2.0			70526	85827
> 16.2.2			69897	85231
> 16.2.4			64713	84046
> 16.2.5			62099	85053
> 16.2.6			68394	83070
> 16.2.7			66974	78601
>
> 		
> Read			4k 4qd	4k 64qd
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 14.2.16			692848	816109
> 14.2.22			693027	830485
> 15.2.14			676784	702233
> *15.2.14 – canonical	749404	792385
> 16.2.0			610798	636195
> 16.2.2			606924	637611
> 16.2.4			611093	630590
> 16.2.5			603162	632599
> 16.2.6			603013	627246
> 16.2.7			-	-
>
> * Very oddly the best perf was achieved with build Ceph 15.2.14 from canonical 15.2.14-0ubuntu0.20.04.2
> 14.2.22 performs very well
> 15.2.14 from canonical is the best in terms of writes.
> 16.2.x series writes are quite poor comparing to other versions.
>
> BW tests
> ========
> - sequential IO 64k, 64qd
>
> These results are mostly the same for all ceph versions.
> Writes ~4.2 GB/s
> Reads ~12 GB/s
>
> Seems that results here are limited by network bandwitdh.
>
>
> Questions
> ---------
> Is there any reason for the performance drop in 16.x series?
> I'm looking for some help/recommendations to get as much IOPS as possible (especially for writes, as reads are good enough)
>
> We've been trying to find out what makes the difference in canonical builds. A few leads indicates that
> extraopts += -DCMAKE_BUILD_TYPE=RelWithDebInfo was not set for builds from ceph foundation
> https://github.com/ceph/ceph/blob/master/do_cmake.sh#L86
> How to check this, would someone be able to take a look there?
>
> BR
> Bartosz Rabiega
>

