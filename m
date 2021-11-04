Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F7144560C
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 16:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhKDPMN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 11:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhKDPMM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 11:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C8D61244;
        Thu,  4 Nov 2021 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636038574;
        bh=ifwFRJOtxIAgi3YdD5ELIcT21UTszvpduiP183mPeRE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Oqg61gZVsJ9MS4QPEEux1j8z+uYsgllgJwG4RdnZOvFrVe/a3riKCBTh+WbmPXYAp
         NV88sbASbPh07kNLCIsCPLgME3SSNcrLyDvugQuP6Sr0Z99B8uvLca9Usx8WUzb1Du
         VZSocrcig4FcgrT9yrpMb5Shfk9VidKyrk3OoCwsHi6nMYAd2HhpOlsk9k6pfmUDR2
         wZW6a5e7q53FHKaksZWtxSaCv/OcCpy0d/vnkHIzVyXphEZKIfmX2xw3RXrxNYEKwC
         TGxCXcBme7u/1xjTVRF2zab5mLUMxdZam8+rS7ghlrl367KLPaS7akAdpGuYzGkjgT
         yqmKFFMD7PlxQ==
Message-ID: <b2fcd4ff9dd84ceb90650d24b56bd704985c85b8.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: metrics for remote object copies
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Nov 2021 11:09:32 -0400
In-Reply-To: <20211104123147.1632-1-lhenriques@suse.de>
References: <20211104123147.1632-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-11-04 at 12:31 +0000, Luís Henriques wrote:
> Hi!
> 
> Here's v2 of this patchset.  The differences from v1:
> 
>   * Instead of changing ceph_osdc_copy_from() in libceph.ko to return an
>     osd request, move that function into the cephfs code instead.
> 
> Other than that, the 2nd patch is quite similar to the one from v1: it
> effectively hooks the 'copyfrom' metrics infrastructure.
> 
> Luís Henriques (2):
>   ceph: libceph: move ceph_osdc_copy_from() into cephfs code
>   ceph: add a new metric to keep track of remote object copies
> 
>  fs/ceph/debugfs.c               |  3 +-
>  fs/ceph/file.c                  | 78 ++++++++++++++++++++++++++++-----
>  fs/ceph/metric.h                |  8 ++++
>  include/linux/ceph/osd_client.h | 19 ++++----
>  net/ceph/osd_client.c           | 60 ++++---------------------
>  5 files changed, 94 insertions(+), 74 deletions(-)
> 

Looks good. Thanks, Luis. Merged into testing branch.
-- 
Jeff Layton <jlayton@kernel.org>
