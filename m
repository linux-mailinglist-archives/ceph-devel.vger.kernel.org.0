Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79348D08F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 03:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiAMCyQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 21:54:16 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35030 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231815AbiAMCyP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 21:54:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1hGTZ0_1642042452;
Received: from 30.225.24.62(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0V1hGTZ0_1642042452)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 10:54:13 +0800
Message-ID: <b274b05b-db23-2b11-c347-fbfe3de0917d@linux.alibaba.com>
Date:   Thu, 13 Jan 2022 10:54:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] netfs: make ops->init_rreq() optional
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
References: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
 <693ab77bab10b38b1ddab373211c24722e79fee2.camel@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-cachefs@redhat.com
From:   JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <693ab77bab10b38b1ddab373211c24722e79fee2.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi David,

ping...


On 1/7/22 5:49 AM, Jeff Layton wrote:
> 
> This looks reasonable to me, since ceph doesn't need anything here
> anyway.
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> 

-- 
Thanks,
Jeffle
