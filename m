Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96087189017
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 22:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgCQVJU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 17:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgCQVJU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 17:09:20 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E032051A;
        Tue, 17 Mar 2020 21:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584479359;
        bh=w8xCM/HztkQxHDdezg4tN9w3NeeMn6Iq2OPPLqSwUBE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=2CC1GM47J+q4vsbQNzUwOy+5hQhVdEFr+Teo2vdR6ISSeG/sIpqa2na8l0Q2ejMSO
         B09xBJ0hXI7YuzrUH4OmfKgGW/r6GMPMCWu+ReJr7wJblMf0xkMArxInnYM91jtD9O
         qdqGH4kPr0E4w3vQ6QDjPahWZ4NYqXvDakYVt8Ks=
Message-ID: <7041ef971bd2c7fdb560f933d736ae6755dd1d9b.camel@kernel.org>
Subject: Re: [ceph-client:testing 49/53] fs/ceph/debugfs.c:140: undefined
 reference to `__divdi3'
From:   Jeff Layton <jlayton@kernel.org>
To:     kbuild test robot <lkp@intel.com>, Xiubo Li <xiubli@redhat.com>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 17 Mar 2020 17:09:17 -0400
In-Reply-To: <202003180447.JrVfA6N9%lkp@intel.com>
References: <202003180447.JrVfA6N9%lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-18 at 04:35 +0800, kbuild test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   3188fc411f0c286ac4dc4ea146ddc4bf4f348b39
> commit: dc1961a859fe49cad7a26001bd3e9a53f234bf59 [49/53] ceph: add global read latency metric support
> config: i386-randconfig-e002-20200317 (attached as .config)
> compiler: gcc-7 (Debian 7.5.0-5) 7.5.0
> reproduce:
>         git checkout dc1961a859fe49cad7a26001bd3e9a53f234bf59
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: fs/ceph/debugfs.o: in function `metric_show':
> > > fs/ceph/debugfs.c:140: undefined reference to `__divdi3'
> 
> vim +140 fs/ceph/debugfs.c
> 
>    126	
>    127	static int metric_show(struct seq_file *s, void *p)
>    128	{
>    129		struct ceph_fs_client *fsc = s->private;
>    130		struct ceph_mds_client *mdsc = fsc->mdsc;
>    131		int i, nr_caps = 0;
>    132		s64 total, sum, avg = 0;
>    133	
>    134		seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
>    135		seq_printf(s, "-----------------------------------------------------\n");
>    136	
>    137		total = percpu_counter_sum(&mdsc->metric.total_reads);
>    138		sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
>    139		sum = jiffies_to_usecs(sum);
>  > 140		avg = total ? sum / total : 0;

Thanks kbuild bot!

Old 32-bit arches can't do division on long long (64-bit) values. The
right fix for this is probably to use do_div(sum, total), instead of
trying to do this with normal integer division.

-- 
Jeff Layton <jlayton@kernel.org>

