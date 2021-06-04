Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4939B7CD
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 13:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFDLX0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 07:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhFDLXZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F153613AC;
        Fri,  4 Jun 2021 11:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622805699;
        bh=3+4QvHQEnFQ0JMZOm4IZvcDSg9fuheR3V9EKPWIMEUg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DxgDs1O9P/x6CX/dzClBmyXiCtZJdNJdQEtbJlJHUyKX98/NR/OLuhSfVmRrKC4Qe
         mFazweYp6I2q2I2D8zONvbvYS4ct4+yUQKxyIurax/GyYZoLSWwHdqWWotZBgL6yc1
         oc1r2WIQfxbpGmjmnKJYiaUOSP84fxAIt0z7WPwNzVe83MLBxpA1PpYfSOKIEeMSTx
         KIHuAfHqr9Q324r/cQHKso7o7ezp+86/VY95JOmRCN6ZTPGpm4HoSNGPTiY1X/DdBF
         3101qAgRF/2cu1EiCXLti5bDhZOEjC3Z1F7L/XZxPsmow5IcB3qBcfeFzEFVc/dY8f
         92kbGksgyQd7A==
Message-ID: <c3b83ff22d22114f02775ee475d5de4f95e58059.camel@kernel.org>
Subject: Re: [PATCH 0/3] ceph: use new mount device syntax
From:   Jeff Layton <jlayton@kernel.org>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Fri, 04 Jun 2021 07:21:38 -0400
In-Reply-To: <20210604050512.552649-1-vshankar@redhat.com>
References: <20210604050512.552649-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-04 at 10:35 +0530, Venky Shankar wrote:
> This series introduces changes Ceph File System mount device string.
> Old mount device syntax (source) has the following problems:
> 
> mounts to the same cluster but with different fsnames
> and/or creds have identical device string which can
> confuse xfstests.
> 
> Userspace mount helper tool resolves monitor addresses
> and fill in mon addrs automatically, but that means the
> device shown in /proc/mounts is different than what was
> used for mounting.
> 
> New device syntax is as follows:
> 
>   cephuser@mycephfs2=/path
> 
> Note, there is no "monitor address" in the device string.
> That gets passed in as mount option. This keeps the device
> string same when monitor addresses change (on remounts).
> 
> Also note that the userspace mount helper tool is backward
> compatible. I.e., the mount helper will fallback to using
> old syntax after trying to mount with the new syntax.
> 
> The user space mount helper changes are here:
> 
>     http://github.com/ceph/ceph/pull/41334
> 
> 
> Venky Shankar (3):
>   ceph: new device mount syntax
>   ceph: record updated mon_addr on remount
>   doc: document new CephFS mount device syntax
> 
>  Documentation/filesystems/ceph.rst | 16 +++++--
>  fs/ceph/super.c                    | 75 +++++++++++++++++++++---------
>  fs/ceph/super.h                    |  1 +
>  3 files changed, 67 insertions(+), 25 deletions(-)
> 

Nice work, Venky!

This looks good at first glance. The only real issue I see is that we
can't just deprecate the mds_namespace option. I think we have to keep
that around for now for the case of a legacy mount helper.

I'll plan to pull down this and your userland patches and give them a
spin later today.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

