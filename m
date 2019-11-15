Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F267FFE38A
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2019 18:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKORCj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 Nov 2019 12:02:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39451 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfKORCi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 15 Nov 2019 12:02:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so11205765wmi.4;
        Fri, 15 Nov 2019 09:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fykxRFUewXTqhxPzLjvPI98MIyzE70PLy3rScoiGko=;
        b=DZOghshzEQ8ccsN+pSk+bupjJBWUzBWf3jdQ2VlEpp5uqS47Ot07PeOZmBSLjoYiwS
         oTYlUe+QMg9eD6cEIHsUzR4NXw3gINLkKqfEONL0aenvBLN6Q/YXNj3TEggcETYB2Po6
         MJqKqHCxqIeKePMwELXHUuLzJsxT20wBTH+qBXpyVKh1ELaN0T/YzcCQXJUZ594orTBN
         TdpLx+zEQpqrxZyOS51d+PtvaZJWXyxcP/f7iuMmpPImVbnJBnHq5AJqd4UQqJUKaycg
         qynQo33gAu4XoNkeoAjQr5wzmX4NcY4mNGYn189TwaVycN64mE6azvqO09nn7nr9w1sL
         Aj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0fykxRFUewXTqhxPzLjvPI98MIyzE70PLy3rScoiGko=;
        b=Xuj298nES/P62qADuFDG5KiGgBGBLdJ+jfOY+1cbu2UfDqllkX9I3oDKVXQaVqvTMm
         /xeWPRYG2plrhXmi37ScAxMwHvZStUGDVsYOHSEvbC8iPufm9kg3lDK14tKbybhnLok8
         WoKIHnWHOTiXBX4uHUAFL//abNxrFK1+E1jZgmVf5xVVIGrjsvjGhQdy8x6Q64iNipS1
         DkBNbBkT+HbiJHLE0CHQNx563WLbpIB/IKPdED+R60P9hVpfRnyqLCSx9kV4Z5ZoxjjC
         D5W1qC555b0U/Up9i8oRrcVM8MH2Zij1Rk4/fxQDs7qzQQ8uVHporasmiafiUnVTa0En
         sKYA==
X-Gm-Message-State: APjAAAVFP8SDexzpbu12bq6QQ7jvHeM69NnxQ4ZfLQ37eqJ3Fzqwm3Q2
        kwhUUS/PqKjy1qjCt6LngxoOjJaD
X-Google-Smtp-Source: APXvYqwZa1s1272CfS6w5GVhRGY57HSpURxNFmo7hkgAtO73Fgl9zHfSCO1aqX+KungMbi1TPwIIlA==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr16532741wmi.114.1573837356851;
        Fri, 15 Nov 2019 09:02:36 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q15sm10967360wmq.0.2019.11.15.09.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 09:02:36 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.4-rc8
Date:   Fri, 15 Nov 2019 18:03:09 +0100
Message-Id: <20191115170309.28988-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 31f4f5b495a62c9a8b15b1c3581acd5efeb9af8c:

  Linux 5.4-rc7 (2019-11-10 16:17:15 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc8

for you to fetch changes up to 633739b2fedb6617d782ca252797b7a8ad754347:

  rbd: silence bogus uninitialized warning in rbd_object_map_update_finish() (2019-11-14 19:00:53 +0100)

----------------------------------------------------------------
Two fixes for the buffered reads and O_DIRECT writes serialization
patch that went into -rc1 and a fixup for a bogus warning on older
gcc versions.

----------------------------------------------------------------
Ilya Dryomov (1):
      rbd: silence bogus uninitialized warning in rbd_object_map_update_finish()

Jeff Layton (2):
      ceph: take the inode lock before acquiring cap refs
      ceph: increment/decrement dio counter on async requests

 drivers/block/rbd.c |  2 +-
 fs/ceph/file.c      | 29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 8 deletions(-)
