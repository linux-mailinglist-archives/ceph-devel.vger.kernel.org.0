Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB174C1DC5
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 22:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbiBWVds (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 16:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiBWVdq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 16:33:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA9354ECEF
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 13:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645651996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLFmw9MPa8qMHufyevoopR5dxL7vpjeZod6E0eok630=;
        b=iZM0BKcjN/p1miNuNwy3ItQVEoHe0w8G7YArd9bH4ydEUq3tvAoPwZQ4JklUsDP5K/bYLm
        gIg0gp1Khuxj40FWkkVTFyeej7yYSC12VGQrmPhwr8dgjhBaYJBXXU0p0aXYWNJahIIJd+
        qUskQaWO6nqB9K1MGAzp4VZMQ92Rwrk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-zn1br-x1NaeFq2YKF7nqxg-1; Wed, 23 Feb 2022 16:33:15 -0500
X-MC-Unique: zn1br-x1NaeFq2YKF7nqxg-1
Received: by mail-io1-f72.google.com with SMTP id k9-20020a0566022d8900b0064165576298so223113iow.15
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 13:33:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MLFmw9MPa8qMHufyevoopR5dxL7vpjeZod6E0eok630=;
        b=fSXm2DjRYGqwBYBki4kow+PH0JfYKCFdMuD6E83q6n45rroMd/KE8ZyfYoVoC7fCdE
         Wp8FIXU0ZuVut2CfJy2gsWR1f+ofdxMgt/ludDDk9qRpgSsI8WbMvT89yXNYLRRgige7
         6ragrTnHuJY1GeHL8iSY6U0ZIqMqhl1SnaNCTCPxxH4+5XuiFzBrE2dGh3Psp1dgG6Em
         hV7vrjutqkw5mTbCePKF5Vu+IRjirnIt9CejFni558F8H74OhMILdbdYOkCJkITW/tdo
         5dth0ZaX6jbUQXYyyuSkRpaNXhaC9vQqulXRpOnpKTgL6WL0v5K8CMJMMkSHouMbzE8h
         wZgw==
X-Gm-Message-State: AOAM530g2CMvuFGtB1O5S4FeI9JQvM8tt8dTz5xaMu2t2RysO/bcn/Vw
        yW9sAKfD6c8IXYVdCkEh+cDWsyj8gF6QPiNAI/G9VYxyCtZQ/XfpbKIPkCxf0m8D+rkqT1cKoPp
        czB8B9ljk8bzeUpZYhmXRdw==
X-Received: by 2002:a05:6602:2817:b0:640:d4f5:12b9 with SMTP id d23-20020a056602281700b00640d4f512b9mr980792ioe.35.1645651994220;
        Wed, 23 Feb 2022 13:33:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkiQraDfq1BGRM80qZJE04hwA+TErOJF5ARKDQ4E4t7QLatQXBKDv+OzFtUL3XxitEf5E8Xw==
X-Received: by 2002:a05:6602:2817:b0:640:d4f5:12b9 with SMTP id d23-20020a056602281700b00640d4f512b9mr980774ioe.35.1645651993692;
        Wed, 23 Feb 2022 13:33:13 -0800 (PST)
Received: from [192.168.50.212] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id l8sm476012ilg.73.2022.02.23.13.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 13:33:13 -0800 (PST)
Message-ID: <d6092114-9f99-157d-1808-10bd7f0bc446@redhat.com>
Date:   Wed, 23 Feb 2022 15:33:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Benching ceph for high speed RBD
Content-Language: en-US
To:     Bartosz Rabiega <bartosz.rabiega@ovhcloud.com>, dev <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <d55c21fb8ba54ee1b8b1e60ccc0bb21b@ovhcloud.com>
 <47a841af-6bcd-8e8d-d6dd-2071f435bd6f@redhat.com>
 <2062509e562b439098aef109146d2cf9@ovhcloud.com>
From:   Mark Nelson <mnelson@redhat.com>
In-Reply-To: <2062509e562b439098aef109146d2cf9@ovhcloud.com>
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


Yep, my IOPS results are calculated the same way.  Basically just a sum 
of the averages as reported by fio with numjobs=1.  My numbers are 
obviously higher, but I'm giving the OSDs a heck of a lot more CPU and 
aggregate PCIe/Mem bus than you are so it's not unexpected.  It's 
interesting that 15.2.14 is showing the best results in your testing but 
none of the 15.2.X tests in my setup showed any real advantage.  Perhaps 
it has something to do with the way you aged/upgraded the cluster.


One issue that may be relevant for you:  At the 2021 Supercomputing Ceph 
BOF, Andras Pataki from the Flatiron Institute presented findings on 
their dual socket AMD Rome nodes where they were seeing significant 
performance impact when running lots of NVMe drives.  They believe the 
result was due to PCIe scheduler contention/latency with wide variations 
in performance depending on which CPU OSDs landed on relative to the 
NVMe drives and network.  AMD Rome systems typically have a special bios 
setting called "Preferred I/O" that improves scheduling for a single 
given PCIe device (which works), but at the expense of other PCIe 
devices so it doesn't really help.  I don't know if there is a recording 
of the talk, but it was extremely good. I suspect that may be impacting 
your tests, especially if the container setup is resulting in lots of 
OSDs landing on the wrong CPU relative to the NVMe drive.


Mark


On 2/23/22 14:05, Bartosz Rabiega wrote:
> Hey Mark,
>
> I forgot to explain what actually are the numbers in my tests.
> It's an average IOPS of the entire cluster according to formula
>
> Result = SUM(avg iops rbd1, avg iops rbd2, ..., avg iops rbd128)
> where "avg iops rbd1" - is avg iops reported by fio (fio runs 1 job 
> per image)
>
> Is that also the case for your results?
>
> As for the cluster aging and run times.
> - each test run took 10mins
> - the cluster was a long lasting one, upgraded multiple times 
> (starting from 14.2.16, .22, 15.2.14 and so on)
> - I tried with a fresh cluster as well, 15.2.14 from canonical always 
> leads.
>
> I also ran longer tests (1h and 2h 4k writes, 15.2.14, and 16.2.x series).
> The perf looks stable and is more less in line with the results I've 
> presented. What's more the perf looks stable.
>
> These are my FIO settings which I find relevant:
>   --cpus_allowed_policy split
>   --randrepeat 0
>   --disk_util 0
>   --time_based
>   --ramp_time 10
>   --numjobs 1
>   --buffered 0
>
> Also I did some tests with custom build of 16.2.7:
> - march znver2
> - O3
> - gcc and clang
> - link time optimization
>
> The performance for reads was improved but for writes it was quite 
> unstable (observed on all my custom builds).
> I'll try to share more results and some screens with timeseries soon.
>
> If there's something you'd like me to test on my setup then feel free 
> to let me know.
>
> BR
> ------------------------------------------------------------------------
> *From:* Mark Nelson <mnelson@redhat.com>
> *Sent:* Wednesday, February 23, 2022 3:26:32 PM
> *To:* Bartosz Rabiega; dev; ceph-devel
> *Subject:* Re: Benching ceph for high speed RBD
> Hi Bartosz,
>
>
> As luck would have it, I've been running through a huge bisection sweep
> lately looking at regressions as well so can give you similar numbers
> for our AMD test cluster. I'll try to format similarly to what you've
> got below.  The biggest difference between our tests is likely that you
> are far more CPU, Memory, and PCIe limited in your tests than I am in
> mine.  You might be in some cases showing similar regression or
> different ones depending on how the test is limited.  Also, I noticed
> you don't mention run times or cluster aging.  That can also have an 
> effect.
>
>
> Hardware setup
> --------------
> 10x backend servers
> CPU: 1x AMD EPYC 7742 64-Core (64c+64t)
> Storage: 6x NVMe (4TB Samsung PM983)
> Network: 100gbps
> OS: CentOS Stream
> Kernel: 4.18.0-358.el8.x86
>
> Server nodes also serving as clients
>
>
> Software config
> ---------------
> 60 OSDs in total (6 OSDs per host)
> 1 OSD per NVMe drive
> Each OSD runs on bare metal
> 4k min_alloc size_ssd (even for previous releases that used 16k)
> rbd cache disabled
> 8GB osd_memory_target
> Scrub disabled
> Deep-scrub disabled
> Ceph balancer off
> 1 pool 'rbd':
> - 1024 PG
> - PG autoscaler off
> - 3x replication
>
>
> Tests
> ----------------
> qd - queue depth (number of IOs issued simultaneously to single RBD image)
>
> Test environment
> ----------------
> - 40 rbd images (default features, size 256GB)
> - All the images have 64GB written before tests are done (64GB dataset 
> per image).
> - client version same as osd version
> - Each node runs fio with rbd engine (librbd) against 4 rbd images 
> (10x4 in total)
> - Ceph is compiled and installed from src.
> - In some cases entire tests were repeated (labeled b, c, d, etc after 
> the verison)
>
> IOPS tests
> ==========
>
> - 4MB, 128KB, and 4KB IO Sizes.
> - read(seq), write(seq), randread, randwrite test types
> - Each combination of io size and test type is run in 1 Sweep
> - Cluster runs 3 sweeps
> - Cluster is rebuilt for every ceph release
> - 300s runtime per test
> - 256qd
>
>
> 4k randwrite    Sweep 0 IOPS    Sweep 1 IOPS    Sweep 2 IOPS    Notes
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 14.0.0          496381          491794 451793          Worst
> 14.2.0          638907          620820 596170          Big improvement
> 14.2.10         624802          565738          561014
> 14.2.16         628949          564055          523766
> 14.2.17         616004          550045          507945
> 14.2.22         711234          654464 614117          Huge start, but 
> degrades
>
> 15.0.0          636659          620931 583773
> 15.2.15         580792          574461 569541          No longer degrades
> 15.2.15b        584496          577238 572176          Same
>
> 16.0.0          551112          550874 549273          Worse than 
> octopus? (Doesn't match prior Intel tests)
> 16.2.0          518326          515684 523475          Regression, 
> doesn't degrade
> 16.2.4          516891          519046          525918
> 16.2.6          585061          595001 595702          Big win, 
> doesn't degrade
> 16.2.7          597822          605107 603958          Same
> 16.2.7b         586469          600668 599763          Same
>
>
> FWIW, we've also been running single OSD performance bisections:
> https://gist.github.com/markhpc/fda29821d4fd079707ec366322662819
>
> I believe at least one of the regressions may be related to
> https://github.com/ceph/ceph/pull/29674
>
> There are other things going on in other tests (large sequential 
> writes!) that are still being diagnosed.
>
> Mark
>
>
> On 2/23/22 05:10, Bartosz Rabiega wrote:
> > Hello cephers,
> >
> > I've recently been doing some intensive performance benchmarks of 
> different ceph versions.
> > I'm trying to figure out perf numbers which can be achieved for high 
> speed ceph setup for RBD (3x replica).
> >  From what I can see there is a significant perf drop on 16.2.x 
> series (4k writes).
> > I can't find any clear reason for such behavior.
> >
> > Hardware setup
> > --------------
> > 3x backend servers
> > CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
> > Storage: 24x NVMe
> > Network: 40gbps
> > OS: Ubuntu Focal
> > Kernel: 5.15.0-18-generic
> >
> > 4x client servers
> > CPU: 2x AMD EPYC 7402 24-Core (48c+48t)
> > Network: 40gbps
> > OS: Ubuntu Focal
> > Kernel: 5.11.0-37-generic
> >
> > Software config
> > ---------------
> > 72 OSDs in total (24 OSDs per host)
> > 1 OSD per NVMe drive
> > Each OSD runs in LXD container
> > Scrub disabled
> > Deep-scrub disabled
> > Ceph balancer off
> > 1 pool 'rbd':
> > - 1024 PG
> > - PG autoscaler off
> >
> > Test environment
> > ----------------
> > - 128 rbd images (default features, size 128GB)
> > - All the images are fully written before any tests are done! 
> (4194909 objects allocated)
> > - client version ceph 16.2.7 vanilla eu.ceph.com
> > - Each client runs fio with rbd engine (librbd) against 32 rbd 
> images (4x32 in total)
> >
> >
> > Tests
> > ----------------
> > qd - queue depth (number of IOs issued simultaneously to single RBD 
> image)
> >
> > IOPS tests
> > ==========
> > - random IO 4k, 4qd
> > - random IO 4k, 64qd
> >
> > Write                 4k 4qd  4k 64qd
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 14.2.16                       69630   132093
> > 14.2.22                       97491   156288
> > 15.2.14                       77586   93003
> > *15.2.14 – canonical  110424  168943
> > 16.2.0                        70526   85827
> > 16.2.2                        69897   85231
> > 16.2.4                        64713   84046
> > 16.2.5                        62099   85053
> > 16.2.6                        68394   83070
> > 16.2.7                        66974   78601
> >
> >
> > Read                  4k 4qd  4k 64qd
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 14.2.16                       692848  816109
> > 14.2.22                       693027  830485
> > 15.2.14                       676784  702233
> > *15.2.14 – canonical  749404  792385
> > 16.2.0                        610798  636195
> > 16.2.2                        606924  637611
> > 16.2.4                        611093  630590
> > 16.2.5                        603162  632599
> > 16.2.6                        603013  627246
> > 16.2.7                        -       -
> >
> > * Very oddly the best perf was achieved with build Ceph 15.2.14 from 
> canonical 15.2.14-0ubuntu0.20.04.2
> > 14.2.22 performs very well
> > 15.2.14 from canonical is the best in terms of writes.
> > 16.2.x series writes are quite poor comparing to other versions.
> >
> > BW tests
> > ========
> > - sequential IO 64k, 64qd
> >
> > These results are mostly the same for all ceph versions.
> > Writes ~4.2 GB/s
> > Reads ~12 GB/s
> >
> > Seems that results here are limited by network bandwitdh.
> >
> >
> > Questions
> > ---------
> > Is there any reason for the performance drop in 16.x series?
> > I'm looking for some help/recommendations to get as much IOPS as 
> possible (especially for writes, as reads are good enough)
> >
> > We've been trying to find out what makes the difference in canonical 
> builds. A few leads indicates that
> > extraopts += -DCMAKE_BUILD_TYPE=RelWithDebInfo was not set for 
> builds from ceph foundation
> > https://github.com/ceph/ceph/blob/master/do_cmake.sh#L86
> > How to check this, would someone be able to take a look there?
> >
> > BR
> > Bartosz Rabiega
> >
>

