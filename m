Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6C37D01
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfFFTMN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 15:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbfFFTMN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 15:12:13 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1144020872;
        Thu,  6 Jun 2019 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559848332;
        bh=7YRIG9AX9cEM3s6rKYJP9drCZyeEG5BrPSihaRIo3iw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mdlK3RyJkGrk5b2FgKhQ7er9JNCtm2CXhtIC9g8LSYcdivl8R1/Bwsubg4uUDIfDJ
         8lfH0hIOZP9sWy4MRGi/hNxkgOjsq4V6z1sIxcuDEi5qzuWDgbXw1PKJ8XD5fBw6KL
         UFJ+KwgVX7VC/PnfhLY3oVmA4F46zFjUkfmrW6F8=
Message-ID: <52aacd32597d3f66b900618d7dddd52b6bd933c7.camel@kernel.org>
Subject: Re: [PATCH 0/2] control cephfs generated io with the help of cgroup
 io controller
From:   Jeff Layton <jlayton@kernel.org>
To:     xxhdx1985126@gmail.com, idryomov@gmail.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Cc:     Xuehan Xu <xxhdx1985126@163.com>, Tejun Heo <tj@kernel.org>
Date:   Thu, 06 Jun 2019 15:12:10 -0400
In-Reply-To: <20190604135119.8109-1-xxhdx1985126@gmail.com>
References: <20190604135119.8109-1-xxhdx1985126@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-04 at 21:51 +0800, xxhdx1985126@gmail.com wrote:
> From: Xuehan Xu <xxhdx1985126@163.com>
> 
> Hi, ilya
> 
> I've changed the code to add a new io controller policy that provide
> the functionality to restrain cephfs generated io in terms of iops and
> throughput.
> 
> This inflexible appoarch is a little crude indeed, like tejun said.
> But we think, this should be able to provide some basic io throttling
> for cephfs kernel client, and can protect the cephfs cluster from
> being buggy or even client applications be the cephfs cluster has the
> ability to do QoS or not. So we are submitting these patches, in case
> they can really provide some help:-)
> 
> Xuehan Xu (2):
>   ceph: add a new blkcg policy for cephfs
>   ceph: use the ceph-specific blkcg policy to limit ceph client ops
> 
>  fs/ceph/Kconfig                     |   8 +
>  fs/ceph/Makefile                    |   1 +
>  fs/ceph/addr.c                      | 156 ++++++++++
>  fs/ceph/ceph_io_policy.c            | 445 ++++++++++++++++++++++++++++
>  fs/ceph/file.c                      | 110 +++++++
>  fs/ceph/mds_client.c                |  26 ++
>  fs/ceph/mds_client.h                |   7 +
>  fs/ceph/super.c                     |  12 +
>  include/linux/ceph/ceph_io_policy.h |  74 +++++
>  include/linux/ceph/osd_client.h     |   7 +
>  10 files changed, 846 insertions(+)
>  create mode 100644 fs/ceph/ceph_io_policy.c
>  create mode 100644 include/linux/ceph/ceph_io_policy.h
> 

(cc'ing Tejun)

This is interesting work, but it's not clear to me how you'd use this in
practice. In particular, there are no instructions for users, and no
real guidelines on when and how you'd want to set these values.

Also, as Tejun pointed out, it's _really_ hard to parcel out resources
properly when you don't have an accurate count of them. AIUI, that's the
primary reason that the cgroup guys like interfaces that deal with
percentages of a whole rather than discrete limits.

I think we'd need to understand how we'd expect someone to use this in
practice before we could merge this. At a bare minimum, a description of
how you're setting them in your environment, and how you're gauging
things like the total bandwidth and iops for the clients.
-- 
Jeff Layton <jlayton@kernel.org>

