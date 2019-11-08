Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7284F5A62
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 22:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfKHVuF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 16:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfKHVuF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 16:50:05 -0500
Subject: Re: [GIT PULL] Ceph fixes for 5.4-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573249805;
        bh=wB44KTNLx4zivLpP5jo3n08ALKXJKuThlbJQVcom1cY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rbvH3ylTTfDKN1altPwkWGqGRZnRKnu6S++B+fTmlpXV2hm70vVcXBYI4D+6ryLan
         BNucHxaz0GYTRzjwINhZn544D4xRDJt/ZlOVxKA2y4BqBkk2Gokc8atRkXfYWffYuE
         6iw2z0Yk+PrhZAW/7MfjA66NYVsFPFA2Z5U7tgBk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191108155853.23314-1-idryomov@gmail.com>
References: <20191108155853.23314-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191108155853.23314-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.4-rc7
X-PR-Tracked-Commit-Id: ff29fde84d1fc82f233c7da0daa3574a3942bec7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0689acfad34e4f60a25e354af2835e1569da81ba
Message-Id: <157324980496.30145.3297312279339956877.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Nov 2019 21:50:04 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Fri,  8 Nov 2019 16:58:53 +0100:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0689acfad34e4f60a25e354af2835e1569da81ba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
