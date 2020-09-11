Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233B12669BD
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Sep 2020 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgIKUtT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Sep 2020 16:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIKUtO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Sep 2020 16:49:14 -0400
Subject: Re: [GIT PULL] Ceph fix for 5.9-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599857354;
        bh=x6YmvRxStXhK9TYbJsm7b5jb1u+T1wIfKQm7uXxL3e4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vsTtiDYiFJ6X7EiKbC39j5f4NdYJlg6eIZ3LyVhhFjd2xdf6gIyD/47WHOzS/2YD2
         9f+l85HzgPRnRrO2ag8VHB2QFgipDquPVKE+TjPkmELypy/1PztWs19jYLkUd6+iQb
         RDfJAW91rESeHyvYxsMrvhpb4Dm/0CLmJQmP/B4k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200911142037.23366-1-idryomov@gmail.com>
References: <20200911142037.23366-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200911142037.23366-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.9-rc5
X-PR-Tracked-Commit-Id: f44d04e696feaf13d192d942c4f14ad2e117065a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 729e3d091984487f7aa1ebfabfe594e5b317ed0f
Message-Id: <159985735446.7850.10669983590448571472.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Sep 2020 20:49:14 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri, 11 Sep 2020 16:20:37 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.9-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/729e3d091984487f7aa1ebfabfe594e5b317ed0f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
