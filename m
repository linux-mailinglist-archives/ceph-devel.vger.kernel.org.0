Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063FE3C2895
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jul 2021 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhGIRoU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jul 2021 13:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhGIRoT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 9 Jul 2021 13:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B37E61355;
        Fri,  9 Jul 2021 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625852496;
        bh=HMqOvaYLTou3mTCIRv6S+zTU+I/qP7tcTRfW1HQbnug=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YcyYhJUKApQrmVJ0k3w8mA/WU9bS8suQYsJOwHRrGCUaR9KJd70LOQydOm/4jzK4S
         F8RI3O/6VR3k7+oKSzNu9wYIlkXidlrtgMrMgBsj44mZBpd03FmT1i0oh2KvF8vvGO
         FYCwV8HOe7MfGh4GP1puAeVqLEDhF0NhxAZ6xyHnpcitEoz58svr3eN9ng2aHrrLdW
         JfGXfVNOjf7hJKUeKyH+Xf0CvVddNOAjWn3FhzZfqidPKPeqrF8UhT5dIyuG1a2BwQ
         yGuX0x8LI1F/cxbibmZE+7ylYfqchtKHTjg3GU7xTsk4bc3b6syZ2DNfw4RIQCfCSO
         QRK9EWuE+foCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 013B5609F6;
        Fri,  9 Jul 2021 17:41:36 +0000 (UTC)
Subject: Re: [GIT PULL] Ceph updates for 5.14-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210708195458.14317-1-idryomov@gmail.com>
References: <20210708195458.14317-1-idryomov@gmail.com>
X-PR-Tracked-List-Id: <ceph-devel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210708195458.14317-1-idryomov@gmail.com>
X-PR-Tracked-Remote: https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc1
X-PR-Tracked-Commit-Id: 4c18347238ab5a4ee0e71ca765460d84c75a26b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 47a7ce62889a52841bcc8cec98dd3bf45af3b4f0
Message-Id: <162585249599.25269.4950112226626666845.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Jul 2021 17:41:35 +0000
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The pull request you sent on Thu,  8 Jul 2021 21:54:58 +0200:

> https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/47a7ce62889a52841bcc8cec98dd3bf45af3b4f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
