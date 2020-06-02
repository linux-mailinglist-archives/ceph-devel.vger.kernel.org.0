Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297911EB36C
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jun 2020 04:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFBCmG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 22:42:06 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:58924 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgFBCmE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 22:42:04 -0400
Received: from [10.0.2.15] (unknown [218.94.118.90])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id CA521C1794;
        Tue,  2 Jun 2020 10:34:28 +0800 (CST)
Subject: Re: [PATCH 0/2] rbd: compression_hint option
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Jason Dillaman <jdillama@redhat.com>
References: <20200601195826.17159-1-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <f5dc6344-a2eb-1991-7a91-de0b41f32ba8@easystack.cn>
Date:   Tue, 2 Jun 2020 10:34:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200601195826.17159-1-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTENIS0tLSUhLTENCSkNZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw5FQNDKEsODy0ePCsuQjocVlZVT04oSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxQ6Khw6Mzg6ET0UPi4vFh4W
        Th4KCUNVSlVKTkJKS01OSU1CSktLVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSkxCTzcG
X-HM-Tid: 0a7272e152ff2085kuqyca521c1794
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reviewed-by: Dongsheng Yang<dongsheng.yang@easystack.cn>


Thanx

Yang

ÔÚ 6/2/2020 3:58 AM, Ilya Dryomov Ð´µÀ:
> Hello,
>
> This adds support for RADOS compressible/incompressible allocation
> hints, available since Kraken.
>
> Thanks,
>
>                  Ilya
>
>
> Ilya Dryomov (2):
>    libceph: support for alloc hint flags
>    rbd: compression_hint option
>
>   drivers/block/rbd.c             | 44 ++++++++++++++++++++++++++++++++-
>   include/linux/ceph/osd_client.h |  4 ++-
>   include/linux/ceph/rados.h      | 14 +++++++++++
>   net/ceph/osd_client.c           |  8 +++++-
>   4 files changed, 67 insertions(+), 3 deletions(-)
>
