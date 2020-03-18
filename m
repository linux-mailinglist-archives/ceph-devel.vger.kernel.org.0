Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F44189575
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 06:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCRFsu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 01:48:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49772 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726550AbgCRFst (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 01:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584510528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+0+TfHvqhYmWsDN5pwkKPKxtK+nSnKnuKqxr1Ngvlw=;
        b=Fv+ql7DgkHqTU4J664gj6IcLsHMrmw+uFJfKh/nrGxuQcT3BWUcZEHXhJcmVW13xBsCAES
        xLeQXi40q9QFibRfizctrk+0jF7vRLtXDsbQSluYzQRYawGABtM01rJwIlUldSMvzpggJN
        sifk/87vX3Jiha53fh5D/r/jvf86kdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-h4ADj221Nj6DkGgLMHWopQ-1; Wed, 18 Mar 2020 01:48:39 -0400
X-MC-Unique: h4ADj221Nj6DkGgLMHWopQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 055908017CC;
        Wed, 18 Mar 2020 05:48:36 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 695535C1BB;
        Wed, 18 Mar 2020 05:48:34 +0000 (UTC)
Subject: Re: [ceph-client:testing 8/8]
 metric.c:(.text.ceph_update_read_latency+0x180): undefined reference to
 `__divdi3'
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
References: <202003181302.3vWy9Yc7%lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f39fa6cd-f17d-10fb-ee86-77d1758c9e58@redhat.com>
Date:   Wed, 18 Mar 2020 13:48:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202003181302.3vWy9Yc7%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/18 13:29, kbuild test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   9707d15b204bb0c87dbb2a8e6ac97d012582510e
> commit: 9707d15b204bb0c87dbb2a8e6ac97d012582510e [8/8] ceph: add standard deviation support for read/write/metadata perf metric
> config: mips-allyesconfig (attached as .config)
> compiler: mips-linux-gcc (GCC) 9.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 9707d15b204bb0c87dbb2a8e6ac97d012582510e
>          # save the attached .config to linux build tree
>          GCC_VERSION=9.2.0 make.cross ARCH=mips
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     mips-linux-ld: fs/ceph/debugfs.o: in function `metric_show':
>     debugfs.c:(.text.metric_show+0x19c): undefined reference to `__divdi3'
>     mips-linux-ld: debugfs.c:(.text.metric_show+0x340): undefined reference to `__divdi3'
>     mips-linux-ld: debugfs.c:(.text.metric_show+0x4e0): undefined reference to `__divdi3'
>     mips-linux-ld: fs/ceph/metric.o: in function `ceph_update_read_latency':
>>> metric.c:(.text.ceph_update_read_latency+0x180): undefined reference to `__divdi3'
>     mips-linux-ld: fs/ceph/metric.o: in function `ceph_update_write_latency':
>>> metric.c:(.text.ceph_update_write_latency+0x160): undefined reference to `__divdi3'
>     mips-linux-ld: fs/ceph/metric.o:metric.c:(.text.ceph_update_metadata_latency+0x160): more undefined references to `__divdi3' follow

The patch series [1] should have fixed all the __divdi3 issues.

[1] https://patchwork.kernel.org/project/ceph-devel/list/?series=258001

Thanks

BR



> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


