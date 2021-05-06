Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FE33759D5
	for <lists+ceph-devel@lfdr.de>; Thu,  6 May 2021 19:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhEFR61 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 May 2021 13:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhEFR60 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 May 2021 13:58:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 575A5610F7;
        Thu,  6 May 2021 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620323848;
        bh=Z4z9nYzQv8hcryg4lD2w9K3lQqPm8sD1nQ4E46xXJHQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fxyK1X1+DoBPCFhkdAvf/V5N2VOlD3AKkBYPn0NJkax1XGPFx6t4RsaYvlOrm1ejr
         yRimXJc2Ctzj/hdgz5rRkbPGsOJTKHfNKR6+LLOhRtZCOGrdk/7qBxB4jHE/jD7llf
         SGmJSfYdBKpvzbnqS4PA3YBaBo/1N+eS0c6RIYRjM/ArIdvzirjBGdS/xivbtcC7Pw
         zyRXR442PR/euxIvQ6ul/+7LvkAX5ZEDh9Z9LE8UoWRgfjfwY6Js9nDlat7wubGrdW
         NsAMuUbRtTd1/LKd+RDUG0eXfPyrWS1xJSFPzy85YCX+KT6ggYqbA3JaKp/cnB+vfS
         Mi6Q+9CDHxtmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4902A60A0C;
        Thu,  6 May 2021 17:57:28 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210506143312.22281-1-idryomov@gmail.com>
References: <20210506143312.22281-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210506143312.22281-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc1
X-PR-Tracked-Commit-Id: 3f1c6f2122fc780560f09735b6d1dbf39b44eb0f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ac86b3dca1b00f5391d346fdea3ac010d230667
Message-Id: <162032384828.1989.7479379818849335011.pr-tracker-bot@kernel.org>
Date:   Thu, 06 May 2021 17:57:28 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu,  6 May 2021 16:33:12 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ac86b3dca1b00f5391d346fdea3ac010d230667

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
