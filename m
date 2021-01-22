Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8D6300976
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Jan 2021 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbhAVQHR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Jan 2021 11:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbhAVQG4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Jan 2021 11:06:56 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E8FC061786;
        Fri, 22 Jan 2021 08:06:16 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id h16so7137693edt.7;
        Fri, 22 Jan 2021 08:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kkODdF815DQqaUMAqusF0BeWMesmAfyR8ldEcgWvCuE=;
        b=UPieOxfqjkoQqyLGY45+TFgjpFPDuWKjE4bjmPAH1Y8inP1cw61IJIZu6jP2EIczuz
         NF+G19ax5NpoA/ezJ9liWItvtP1W47Ddi14GiZYD7ckI7Z+ragNF5cnXHl9zv22c1bN+
         7/a5Z0N10tPo6Cb7+kSbKNJvt6rALrwsPAmwRqmb/0fp5DUhDcJIR1vl80oQUkYZHG/F
         jAu4HBjZiHvc3qI2gEjU6L40BnJIvXg3bPSPXNtqBuM7ZXkL8Nk3Jwfrlt7+S1mwn9Xi
         qQxMvjBS1WW0O42hWUlQD+VkE9ePuPNWtbXGBzmkSXwud6THtcT8j1VJCA7c8rs55wbi
         PR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kkODdF815DQqaUMAqusF0BeWMesmAfyR8ldEcgWvCuE=;
        b=hOjJkoTc+3CDdtgcYC+MLa3oA7nye3cyWAA8Sy+hklVGI7qWKve4t8AJ7Kee0UTEnt
         6KQfDzNk9c9w6j/ZicbM9j4Lw+t44mCsfzcG8FBR1oW3Llg3liZpc0lgZ0hvGozeA6kS
         bSE62YZKJWu22HL3kJ9KgFL6W4fdfGz0Ufa8j6x3w74yx6yJCVItP1SVkPf3wwMgTJJt
         0Pg+e++nQ6a4zD+29jOAEXiZM/Q0KUdmwsAtR5PPphhfhh1QE/Xbwsk7zeGRqzHY+oCI
         wqLbzAC0HhmM1JFy4yMHXcH54uQqxzyPbK9QSpBqMZW4V/+5VXo77jcSefcMiqljU0OD
         0UtA==
X-Gm-Message-State: AOAM531xxj71bVlRgiqEHzTyUL0opxYKlVBI7bL43XMplYfi1d2XSVw+
        2Mcdhr1uYw9cLhT16suXjP6hGwnQ0qc=
X-Google-Smtp-Source: ABdhPJxjzOMhqEHkjoZ7Pj311JbBxWdMwPb/bOfqnqbxWfum8CYeJY+ma3ZQROq9SV147jVeeVRLZg==
X-Received: by 2002:a05:6402:32c:: with SMTP id q12mr3780058edw.145.1611331575162;
        Fri, 22 Jan 2021 08:06:15 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id f6sm5555117edv.83.2021.01.22.08.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 08:06:14 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.11-rc5
Date:   Fri, 22 Jan 2021 17:06:05 +0100
Message-Id: <20210122160605.5939-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62:

  Linux 5.11-rc2 (2021-01-03 15:55:30 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.11-rc5

for you to fetch changes up to 9d5ae6f3c50a6f718b6d4be3c7b0828966e01b05:

  libceph: fix "Boolean result is used in bitwise operation" warning (2021-01-21 16:49:59 +0100)

----------------------------------------------------------------
A patch to zero out sensitive cryptographic data and two minor cleanups
prompted by the fact that a bunch of code was moved in this cycle.

----------------------------------------------------------------
Ilya Dryomov (3):
      libceph: zero out session key and connection secret
      libceph, ceph: disambiguate ceph_connection_operations handlers
      libceph: fix "Boolean result is used in bitwise operation" warning

 fs/ceph/mds_client.c    | 34 ++++++++++++++---------------
 net/ceph/auth_x.c       | 57 +++++++++++++++++++++++++++++--------------------
 net/ceph/crypto.c       |  3 ++-
 net/ceph/messenger_v1.c |  2 +-
 net/ceph/messenger_v2.c | 45 +++++++++++++++++++++-----------------
 net/ceph/mon_client.c   | 14 ++++++------
 net/ceph/osd_client.c   | 40 +++++++++++++++++-----------------
 7 files changed, 107 insertions(+), 88 deletions(-)
