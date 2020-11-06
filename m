Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52ED2A9E03
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Nov 2020 20:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgKFT1w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Nov 2020 14:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgKFT1w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Nov 2020 14:27:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2DCC0613CF;
        Fri,  6 Nov 2020 11:27:51 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q3so2383170edr.12;
        Fri, 06 Nov 2020 11:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zudEAR/I5Al2cSyHqgZYcwuZhN0AmEO/U0JSCqNh/mo=;
        b=pVY4Nv+qY9Q/0jvmAFSvN+UUCDwEskK2v7w5NJIrhElojR2e9T4rQ+3ONP/0KGmps9
         Z+so8DvHNqBstvblmf7l3hySSDUECnwm0MK6QILFgGa7LAURh3aY/Zhcu/mT9B3khSb+
         j2ecnMAYl+a8UoOGdCwe4sP09VMsqjHFsgz/azSI5TX6XHyhSJ39aTUA26XKZ6uRU7Je
         hV6yIlKatroSlO2557RaOdqCurAUFw9TLf0kGjYR161Qep5XhebxwdkhtG04qYEkhIgl
         Z/pWgJzEJJb8rwdrOBNPwcb751ROluEhHeFDQ9x5WXGZPHFUhSPetui4vHQUNB5zB0UU
         MKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zudEAR/I5Al2cSyHqgZYcwuZhN0AmEO/U0JSCqNh/mo=;
        b=qEyjVrAaSxXN9/QMbCwMAOfs6MtLUVC6ZH2ul2rEI630d1g0K3aELSWWCnRu+kRJQP
         NwE1S45BxxiTmCWN9Khkha6vlvou3C/upXMx6ZZSOPL9raXL7IkgD5u2rkv3mfXW66f5
         Djt6ZWF7/q8+JnMYnnAjb7C4awglwpgCWVIH5J7qYi0hW9+zjt6NIIfZqu8aMf1kpkns
         veVFphfP/DMbItIvIUqiNYgdR60v6Qh64OLjd3ZQ+vw2kuJELvtgLS9i5ojAsGCMTFd9
         UO5PxF+NrZQjxFMalQyxWVj5VA3wwfI0AVVF/DEw45kxCvBjf3x5k01nJzi7TkLXHHxP
         M1oQ==
X-Gm-Message-State: AOAM533xFOMr+ce9OHkIMNHYmz5jeagjecOUsJllKGoEICJG/NnMQ3r0
        4HNDZrRNCk/0hK0KDgrtwqJVlMQLBYfbhA==
X-Google-Smtp-Source: ABdhPJwMYXKjp47fPDssWdk/4AXjKV/voTNf03nsmqcWvdK4GJO0wvq1oz83zj+dEtUAuoxVo6ImJg==
X-Received: by 2002:aa7:d858:: with SMTP id f24mr3585997eds.12.1604690869392;
        Fri, 06 Nov 2020 11:27:49 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id 11sm1559425ejy.19.2020.11.06.11.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 11:27:48 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 5.10-rc3
Date:   Fri,  6 Nov 2020 20:27:50 +0100
Message-Id: <20201106192750.32141-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 3cea11cd5e3b00d91caf0b4730194039b45c5891:

  Linux 5.10-rc2 (2020-11-01 14:43:51 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.10-rc3

for you to fetch changes up to 62575e270f661aba64778cbc5f354511cf9abb21:

  ceph: check session state after bumping session->s_seq (2020-11-04 20:55:49 +0100)

----------------------------------------------------------------
A fix for a potential stall on umount caused by the MDS dropping
our REQUEST_CLOSE message.  The code that handled this case was
inadvertently disabled in 5.9, this patch removes it entirely and
fixes the problem in a way that is consistent with ceph-fuse.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: check session state after bumping session->s_seq

 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 50 +++++++++++++++++++++++++++++++++++---------------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/quota.c      |  2 +-
 fs/ceph/snap.c       |  2 +-
 5 files changed, 39 insertions(+), 18 deletions(-)
