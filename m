Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E05116C8C
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 12:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfLILwc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 06:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbfLILwc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 06:52:32 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D7E2077B;
        Mon,  9 Dec 2019 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575892351;
        bh=tj4U2OvPqGxGv9tQEzb259lfmmBVjItbP5zMiQ/Tu8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YAMPj8WOEVawoQH6skAeT2VeUpTVTLKU/evLMNaI4TgLUv3/c0UlmR1vjUbTIfft3
         cARnnpyxULd0h+BUEwWbhlYcxFTuTqQSpGdhOiMVLa9rbLbJ8WYRVo8unk5vQhVVlH
         48ykTM5D977TF+0TDYPnH1P5I5Bo5rtw9RyPq3T0=
Message-ID: <42ac207bc9f21b004a24f0c309c8fe456a6a5f4f.camel@kernel.org>
Subject: Re: [PATCH] ceph: keep the session state until it is released
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 09 Dec 2019 06:52:30 -0500
In-Reply-To: <20191206033551.34802-1-xiubli@redhat.com>
References: <20191206033551.34802-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-12-05 at 22:35 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When reconnecting the session but if it is denied by the MDS due
> to client was in blacklist or something else, kclient will receive
> a session close reply, and we will never see the important log:
> 
> "ceph:  mds%d reconnect denied"
> 
> And with the confusing log:
> 
> "ceph:  handle_session mds0 close 0000000085804730 state ??? seq 0"
> 
> Let's keep the session state until its memories is released.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  fs/ceph/mds_client.h | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 

Merged into ceph-client/testing.
-- 
Jeff Layton <jlayton@kernel.org>

