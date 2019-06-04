Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98D53414E
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 10:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfFDIOB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 04:14:01 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:44629 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfFDIOB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 04:14:01 -0400
Received: by mail-io1-f53.google.com with SMTP id s7so9249554iob.11
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 01:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/+R3ryy9/WqO7OTgJwIswjnUIJKtfOg5UlAcLWx9GjA=;
        b=gX4KE+9tXJLzVc8VLhk7ADbUFlPeB+A3bukjS8KuMlhbGf1OJkphqVyUm3NaE/AIqu
         WxVMy27AnWOfWx3MT7SEL/rvLZoK4BFUaC66/OAvtXgoI5AFWZNdCpeGukeIyc/4HPo2
         f/iW6Pbt5UvUQ/gELxgqGxGCcekxzW6LnjN5VyaY8br8ADrW2onPQ8DjYetQCq98esz3
         +V3ftBGmfoQ4pCHXta9Pte7SX9hF6+MtMq9jtp1xNRTWD3OHoa2S9r+AVCbow608jfHn
         a0BdOf6CEgxGkXTZbKvUXEMs9q3/Bim7p5VdNu3N0XZf7wASi0Sp03uHTfwa3kX8PquG
         WRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/+R3ryy9/WqO7OTgJwIswjnUIJKtfOg5UlAcLWx9GjA=;
        b=SvzJENsZoILfUgO9ox9V1rjQ3d9LWKrKcZi4C709K7dB+p+SaHRmyF7kAxjaF+be8t
         2tsmHexJZ6tM2mgQqWsSbOcB3JQfIzLa5W9AROdCYbbsLf81dU5Mzv+Pxp4Jt0qKoyZh
         vjkI5iHaIsxlV905Qtb8rqZN5G/rwl/D20HDnVaAjhxXS0hEkgUQxFLGH0s8Yo6Kacq6
         BN0y05bQAK/yde2dYpWaMkOJbg8jJMQgWzdiMCD7a3PTgvD8oJLyMcBS2u2dzSZ4WnjJ
         9rCkF68LdlYAxP9Vn8jQdAxyObPJpu+kbwlPQzZ0eloMNoOS5Fu7MC1muGO29F+Vj6kA
         DEZg==
X-Gm-Message-State: APjAAAUbEJ7JIZqxyNc2DSRHjYGnegmXcOXxmX0cOgPmwotyj5mjRzBt
        X3CGOJAtOZEFYAy4Bze54B70zEYv1HsNk0kJ2hqFlsg7
X-Google-Smtp-Source: APXvYqxn48N2GKr1tpARS76CKc93CjzGZZB2fDyDx7HAKxdGquBOeg8tl+i6+Rc8m5pSfOuIWXtzO13iCNWq9PxkXN8=
X-Received: by 2002:a5e:a712:: with SMTP id b18mr17909912iod.220.1559636040468;
 Tue, 04 Jun 2019 01:14:00 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6Z+m55qT6K+a?= <whc0000001@gmail.com>
Date:   Tue, 4 Jun 2019 16:13:49 +0800
Message-ID: <CALbLmkCvybsEWGRoZDjjmr9juYBfzYBfOt+h2F+MAq_2oc=3Mw@mail.gmail.com>
Subject: DPDK memory error when using spdk in 14.2.1
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi~
   I recently tried to use SPDK in version 14.2.1 to speed up access
to nvme. But I encountered the following error when I start osd:

  EAL: Detected 72 lcore(s)
EAL: Detected 2 NUMA nodes
EAL: No free hugepages reported in hugepages-1048576kB
EAL: Probing VFIO support...
EAL: PCI device 0000:1a:00.0 on NUMA socket 0
EAL:   probe driver: 1c5f:550 spdk_nvme
EAL: PCI device 0000:1b:00.0 on NUMA socket 0
EAL:   probe driver: 1c5f:550 spdk_nvme
EAL: PCI device 0000:3e:00.0 on NUMA socket 0
EAL:   probe driver: 1c5f:550 spdk_nvme
/data/weihaocheng/ceph-rpm/rpmbuild/BUILD/ceph-15.0.0-1494-ged2ce0e/src/common/PriorityCache.cc:
In function 'void PriorityCache::Manager::balance()' thread
7f8e8bffc700 time 2019-06-04T15:41:00.171667+0800
/data/weihaocheng/ceph-rpm/rpmbuild/BUILD/ceph-15.0.0-1494-ged2ce0e/src/common/PriorityCache.cc:
288: FAILED ceph_assert(mem_avail >= 0)
 ceph version 15.0.0-1494-ged2ce0e
(ed2ce0efad31b2b953c49be957fd2f46199e84b1) octopus (dev)
 1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x14a) [0x7f9e97084f59]
 2: (()+0x4c5121) [0x7f9e97085121]
 3: (PriorityCache::Manager::balance()+0x421) [0x7f9e9771b2c1]
 4: (BlueStore::MempoolThread::entry()+0x501) [0x7f9e97655601]
 5: (()+0x7e25) [0x7f9e937e4e25]
 6: (clone()+0x6d) [0x7f9e926a5bad]
*** Caught signal (Aborted) **
 Is my system configured incorrect, or dependent versions incorrect or
any bug in the codes?
