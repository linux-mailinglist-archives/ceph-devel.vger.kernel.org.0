Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9E59EA0
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Jun 2019 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF1PRi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Jun 2019 11:17:38 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:33440 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfF1PRi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Jun 2019 11:17:38 -0400
Received: by mail-wm1-f50.google.com with SMTP id h19so9588711wme.0;
        Fri, 28 Jun 2019 08:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ivlQbRnvgnETW0AlAfwHI5U9Vayzy2zmg/NO/SE82Yw=;
        b=jzV3mO/PbwVbL7CaCXw42EA2Ny94MCdapnlbIK/YB0pbnBCjJVnvSDGQrZxupGAW6K
         GwYCJpzcK1mWWUpq1Nfy9kbaeP6h3jA4UDG6EbfVvOChw7aW7Snd3td/0Kdd28ASP7gz
         dMwtaUoHiLHJHupZ1XLrgi/aDPQPbzkRMuqtNWyVQsgWgBCGfjGTsnPavPNmUksDspds
         ed4O/PRzAY2Cl5jZTBa/vtG/wW0JeDPmk6GntjKMo2tbGBO15wH4XRsS/t9fFLwKwKXN
         eiY6WBdPU2AT15ifyCKCE1o8YRzZCQRtxF+DUzG8MUCddL+8zXwaP8vNWJ6kDKyBJ5RZ
         swig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ivlQbRnvgnETW0AlAfwHI5U9Vayzy2zmg/NO/SE82Yw=;
        b=ROxoWp865bOB06YzRfSp7PXmEY2Mik4J05T4+vEDjPWDGilAzOuqbuMNUlFbw9l1Py
         MNtSgPEaGeeAw5fu/eIBC/YNJ7D3X4yaU3ICGDhP2fb6AbLtu0vv3mPVqANgkW9tnPuU
         vFkPiLsVU04O67Nr+lo0qCHQ2jNS7qaMdOx2+G1sE5rKV8MiJVftVvc2PIYVpjvj1bhu
         thwOozK5j6FT4qOJSXEy7ZhUpnhroYL2x6qiuqIoKar0Ut+MiYZ8v6zXJfRzcG0G1THg
         h7VlZV963YvJZSiXvWk9ulFVVZPOkpogLreOiL/NAC25+t3kdvB1GL+ckEuKBL9wFXrR
         bKiA==
X-Gm-Message-State: APjAAAUTEKXS/1sxuaZqq0IiPCPfLKcbI93SHxXQNIq9uqSZnv3utn5A
        aMPBkEIx//8KKRBBayZUX966xZNZxLA=
X-Google-Smtp-Source: APXvYqx5V02oZVueSkzL9YfJ+uB/zyFc6mS8/IatlaZFvthnuRxc++USwHkdgXLBxEuVjOGQPm9uNQ==
X-Received: by 2002:a1c:e341:: with SMTP id a62mr7948352wmh.165.1561735056166;
        Fri, 28 Jun 2019 08:17:36 -0700 (PDT)
Received: from kwango.local (ip-89-102-68-197.net.upcbroadband.cz. [89.102.68.197])
        by smtp.gmail.com with ESMTPSA id y6sm2658497wmd.16.2019.06.28.08.17.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:17:34 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 5.2-rc7
Date:   Fri, 28 Jun 2019 17:17:24 +0200
Message-Id: <20190628151724.5642-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 4b972a01a7da614b4796475f933094751a295a2f:

  Linux 5.2-rc6 (2019-06-22 16:01:36 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.2-rc7

for you to fetch changes up to d6b8bd679c9c8856fa04b80490765c43a4cb613b:

  ceph: fix ceph_mdsc_build_path to not stop on first component (2019-06-27 18:27:36 +0200)

----------------------------------------------------------------
A small fix for a potential -rc1 regression from Jeff.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: fix ceph_mdsc_build_path to not stop on first component

 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
