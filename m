Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF6249961
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 11:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHSJeF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 05:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgHSJeE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 05:34:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67C4206FA;
        Wed, 19 Aug 2020 09:34:03 +0000 (UTC)
Date:   Wed, 19 Aug 2020 12:34:00 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] libceph: add __maybe_unused to DEFINE_CEPH_FEATURE
Message-ID: <20200819093400.GR7555@unreal>
References: <20200819085736.21718-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819085736.21718-1-idryomov@gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 10:57:36AM +0200, Ilya Dryomov wrote:
> Avoid -Wunused-const-variable warnings for "make W=1".
>
> Reported-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/ceph_features.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Even better,
It will be great to see this patch in -rc pull request.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
