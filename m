Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FFD37F6BE
	for <lists+ceph-devel@lfdr.de>; Thu, 13 May 2021 13:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhEMLbh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 May 2021 07:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhEMLbc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 May 2021 07:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EBB460E0B;
        Thu, 13 May 2021 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620905423;
        bh=4dLYPvg0wej8xxokk50TF2wxoFGoMPQe0mAympc0JTA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FmLX/W2FDx8IpqjvhkQu+cDmVrHk67iFL62kLfsxthY/8vdXsfEtPfohq1aA2NI2F
         kzbrOlHGo9p3Q1MbQTCm3eM8MUEvsAkbMCoXKlGwhrX50TpA2Ax+CnupYwNxBLDj5h
         LsqS70dGqpmHE5A//cYMfI6sQTTAkG/YtDiCeNDFCbD/P7fjPknCC26i4Men8h671y
         3qTmxaLGpLhikwn3RZqjkjFs1NpqFBRRtUva5r18jt7jtuvBOorc2RnsFyLERG5Ura
         ZSlGt7BPR9vje88Yr2iwilkx4KCFGzu3Uea4VKyJJEpsojXkvv/BSOeUtZzXoYS6Bt
         7BChs6jkZ4pOA==
Message-ID: <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Date:   Thu, 13 May 2021 07:30:21 -0400
In-Reply-To: <20210513014053.81346-1-xiubli@redhat.com>
References: <20210513014053.81346-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> V2:
> - change the patch order
> - replace the fixed 10 with sizeof(struct ceph_metric_header)
> 
> Xiubo Li (2):
>   ceph: simplify the metrics struct
>   ceph: send the read/write io size metrics to mds
> 
>  fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
>  fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
>  2 files changed, 89 insertions(+), 80 deletions(-)
> 

Thanks Xiubo,

These look good. I'll do some testing with them and plan to merge these
into the testing branch later today.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

