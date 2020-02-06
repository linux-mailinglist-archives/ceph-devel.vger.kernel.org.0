Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3598E15440B
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 13:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBFMaP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Feb 2020 07:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgBFMaP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 07:30:15 -0500
Subject: Re: [GIT PULL] Ceph updates for 5.6-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580992214;
        bh=eV/InsG0hyZln8PijgT1RSVEsRX2h+dSa380+9ElccI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dWokWOz9bVOjRkur79AqrCLPT7/oDhSXNj8w0WStay8+bydsS5pnWZ0f0HYMaHLyH
         ZsFGqpyhET7jwZovnlaWhrVE/Dtjb+gmRD3HmUr2qKirSSKMmAlllCQH72eN7tG4Dp
         u+oTUjOOMl2b3ODi84x4+EN6G6+7qukgby3XZgA8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200206094804.29473-1-idryomov@gmail.com>
References: <20200206094804.29473-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200206094804.29473-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.6-rc1
X-PR-Tracked-Commit-Id: 3325322f773bae68b20d8fa0e9e8ebb005271db5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4c46bef2e96a92df0f40fc91848e56889ef7c15e
Message-Id: <158099221490.14061.493398077206202783.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Feb 2020 12:30:14 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu,  6 Feb 2020 10:48:04 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4c46bef2e96a92df0f40fc91848e56889ef7c15e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
