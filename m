Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814A336D959
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhD1OPI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 10:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhD1OPI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 10:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AB561408;
        Wed, 28 Apr 2021 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619619263;
        bh=qfjO4RsmG3Q3xxxGy8DItkuEjxKPnXa+kXCmPLkiHAY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u0pN4yv1vvKlcJ3tg8rAJAdsar+oPD3JmHo8zQtNtOF1EjcTxuBtDnWSVnPk/ruK6
         oZP/7OUBjtrHMWkJuf+qVKIy/wTfkRP38g8ACX4fmKeoibVzBIVFprscrIw6Xzf6en
         HYEqq32KNrRxdHh1NG6Db/4T8VgjEPOijH9xQxjfQRBvYsGMrlqhTKMyC4thBd31WP
         8jPmOabWtwgfmMT09yZcVaAKe/9DdlegfolP0j7KIr6DOMSWjy8YV9K4cPFWEWGSh2
         8nTOrJc4LY+75WovjqFz4hJZyOUg3tN1uSaYvhE1nFZw2Q7fNke8R3Clh5e/NlAgk1
         XV1JkbvhaKj4g==
Message-ID: <6de87237eca5e9ebd7714755ddd11adb4bc5c5ed.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] ceph: add IO size metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 28 Apr 2021 10:14:21 -0400
In-Reply-To: <20210428060840.4447-1-xiubli@redhat.com>
References: <20210428060840.4447-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-04-28 at 14:08 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> V3:
> - update and rename __update_latency to __update_stdev.
> 
> V2:
> - remove the unused parameters in metric.c
> - a small clean up for the code.
> 
> For the read/write IO speeds, will leave them to be computed in
> userspace,
> 	where it can get a preciser result with float type.
> 
> 
> Xiubo Li (2):
>   ceph: update and rename __update_latency helper to __update_stdev
>   ceph: add IO size metrics support
> 
>  fs/ceph/addr.c    | 14 +++++----
>  fs/ceph/debugfs.c | 37 +++++++++++++++++++++---
>  fs/ceph/file.c    | 23 +++++++--------
>  fs/ceph/metric.c  | 74 ++++++++++++++++++++++++++++++++---------------
>  fs/ceph/metric.h  | 10 +++++--
>  5 files changed, 111 insertions(+), 47 deletions(-)
> 

Thanks Xiubo,

This looks good. Merged into ceph-client/testing.

My only (minor) complaint is that the output of
/sys/kernel/debug/ceph/*/metrics is a bit ad-hoc and messy, especially
when there are multiple mounts. It might be good to clean that up in a
later patch, but I don't see it as a reason to block merging this.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

