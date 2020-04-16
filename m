Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E381ACF23
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgDPRzX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Apr 2020 13:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbgDPRzW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 13:55:22 -0400
Subject: Re: [GIT PULL] Ceph fixes for 5.7-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587059721;
        bh=etVCD76bhHfxKZx+YL8EO2UfLMLM5gDpfBrdGDEmRXw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=c+WRKd6f3DQITdxYwNhPzEKTBM7Qps9SVdGdNQpwO5WY/GLSpACEdz+6rvWDVAgUj
         nK/RCYZtywI4S3lDafWx7LZ7vEgQ5QlmUtGDQ8sSKgjokmIqsmf79JTjVve7z8+0ik
         K+wqZBLxTWT4AUJqUvCtC7pLFb1XzzWkykSMOUfs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200416172321.20778-1-idryomov@gmail.com>
References: <20200416172321.20778-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200416172321.20778-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git
 tags/ceph-for-5.7-rc2
X-PR-Tracked-Commit-Id: 2a575f138d003fff0f4930b5cfae4a1c46343b8f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3fa84bf926f32edf798cfad0317e14df41ac0509
Message-Id: <158705972176.30027.7508667561184560509.pr-tracker-bot@kernel.org>
Date:   Thu, 16 Apr 2020 17:55:21 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu, 16 Apr 2020 19:23:21 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3fa84bf926f32edf798cfad0317e14df41ac0509

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
