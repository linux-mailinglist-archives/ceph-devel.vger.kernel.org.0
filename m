Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3739B3420A
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFDIkR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 04:40:17 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:34935 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFDIkR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 04:40:17 -0400
Received: by mail-it1-f173.google.com with SMTP id n189so12615776itd.0
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 01:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UaWgTwrWQpbPn79otAdoarRJdY2Sau16OQJGXAT0T9Q=;
        b=cRLQSizx4y9uoDneRZcNAZVMbY5oRFxhdWVAIICLRNainQ533iFonVga5Ksh9hfCWU
         TTMYNGhyORAXhsZDM3Q5wHgJdbfw4Hayfpwu08TJHGg2C9Q7Gm3WwgBpMatnnAhoUx+3
         K2UzUPjt1GOCJS9kJFZi+CNWsf5dwuXcxNlHtYVg+luO650leoNOXt5wBsxfDYCqqGMS
         R29THd1+8fUbLm1JGir5bQcsaLLWZmQM2k6Wlrz73KvMd54/w/ogthq7IWWFMV8wcYjY
         HB62P3YvMqhHHgKRjEiAwTfX/gt+nJfGvS0m6lfaL5ANqpcEptHZGJYoTZRIs5jVaE2c
         H4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=UaWgTwrWQpbPn79otAdoarRJdY2Sau16OQJGXAT0T9Q=;
        b=iD52tHIvePptdsZ03PXuserJs6KblS3gg9pV3j/hca+yuapLBkjWTrfWZFWrMSwqHT
         e2kcD8oFLz0sYXHcZxNAb8VP3myM/MRT4nwBTq80Zdkh2j5n/pnbN8MIO008hvt+6nhF
         TS/2EeOecBvr0To221olbhvJdFOfk85PXUE0KnA19YJN6FHPgvRJCqAVOb/2mBzDlR9z
         H+Z1htR1kqgRmsJNwHUyvKH/bgS3nVTbGMB0OXObcrpxAB+2MW1Du2nIkK4BS4ll3prW
         8YgMlMYaqsaINdLJW6tPJZw5ZoTFjV6WFZfU2XoA6OadJjwMUUWGx7HiPDTNGBAacPmi
         7SRA==
X-Gm-Message-State: APjAAAWfRJPYAJ2+ldKPZfyp4pkbazMrE1b/Bvc+Ueb0L6EqB50XoKKE
        HOnNnfpjhcsNtLa+HrLntpQVZ02bPsSm/GWtwPWx2A==
X-Google-Smtp-Source: APXvYqxZglDK3SYTLXu9N7RAg5acdLV9O+fcAOIpQyLUP6PfYO/j/maSPmzSkumK3+8gXc9YMSZE5knMxRij0F0VQq0=
X-Received: by 2002:a24:b648:: with SMTP id d8mr6782859itj.14.1559637615827;
 Tue, 04 Jun 2019 01:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <CALbLmkCvybsEWGRoZDjjmr9juYBfzYBfOt+h2F+MAq_2oc=3Mw@mail.gmail.com>
In-Reply-To: <CALbLmkCvybsEWGRoZDjjmr9juYBfzYBfOt+h2F+MAq_2oc=3Mw@mail.gmail.com>
From:   =?UTF-8?B?6Z+m55qT6K+a?= <whc0000001@gmail.com>
Date:   Tue, 4 Jun 2019 16:40:04 +0800
Message-ID: <CALbLmkAcUKG2yaGe0poCmeSrWSqVEj=mzSFM=mU43HhP6i6aOQ@mail.gmail.com>
Subject: Re: DPDK memory error when using spdk in 14.2.1
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sorry, the ceph version is 15.0.0

=E9=9F=A6=E7=9A=93=E8=AF=9A <whc0000001@gmail.com> =E4=BA=8E2019=E5=B9=B46=
=E6=9C=884=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=884:13=E5=86=99=E9=81=
=93=EF=BC=9A
>
> Hi~
>    I recently tried to use SPDK in version 14.2.1 to speed up access
> to nvme. But I encountered the following error when I start osd:
>
>   EAL: Detected 72 lcore(s)
> EAL: Detected 2 NUMA nodes
> EAL: No free hugepages reported in hugepages-1048576kB
> EAL: Probing VFIO support...
> EAL: PCI device 0000:1a:00.0 on NUMA socket 0
> EAL:   probe driver: 1c5f:550 spdk_nvme
> EAL: PCI device 0000:1b:00.0 on NUMA socket 0
> EAL:   probe driver: 1c5f:550 spdk_nvme
> EAL: PCI device 0000:3e:00.0 on NUMA socket 0
> EAL:   probe driver: 1c5f:550 spdk_nvme
> /data/weihaocheng/ceph-rpm/rpmbuild/BUILD/ceph-15.0.0-1494-ged2ce0e/src/c=
ommon/PriorityCache.cc:
> In function 'void PriorityCache::Manager::balance()' thread
> 7f8e8bffc700 time 2019-06-04T15:41:00.171667+0800
> /data/weihaocheng/ceph-rpm/rpmbuild/BUILD/ceph-15.0.0-1494-ged2ce0e/src/c=
ommon/PriorityCache.cc:
> 288: FAILED ceph_assert(mem_avail >=3D 0)
>  ceph version 15.0.0-1494-ged2ce0e
> (ed2ce0efad31b2b953c49be957fd2f46199e84b1) octopus (dev)
>  1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
> const*)+0x14a) [0x7f9e97084f59]
>  2: (()+0x4c5121) [0x7f9e97085121]
>  3: (PriorityCache::Manager::balance()+0x421) [0x7f9e9771b2c1]
>  4: (BlueStore::MempoolThread::entry()+0x501) [0x7f9e97655601]
>  5: (()+0x7e25) [0x7f9e937e4e25]
>  6: (clone()+0x6d) [0x7f9e926a5bad]
> *** Caught signal (Aborted) **
>  Is my system configured incorrect, or dependent versions incorrect or
> any bug in the codes?
