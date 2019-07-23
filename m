Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8007135A
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2019 09:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388577AbfGWH4H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 03:56:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36937 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfGWH4G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Jul 2019 03:56:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id c9so28602461lfh.4
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2019 00:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3UPj6T+LSG5RBZEWtvjbsFOKqjdqdXnS1AS9OtVMFac=;
        b=tSewB2jurj7agSKoduJkWdtJ2EpYeSAx/NoYvziitN8Jel8DLCqzSiI+Y78aIRarLo
         B5GLSMUAZhGL4oBz1awvzwSdU5t7Hz0+HLti/bpDYdUWnpg5zZuVckrVGn4js2t/iagq
         v7NW1txO1B0A8vu7gVTfELejdpkhprn1wIsFnCEBTnXnNTnPHjj2uHEvhwwrTZoEC2bT
         L0TzuHkC61qheCq4UPO4uDIlrJBqmiNJpUVvrcZlumN2OACmmsbncYthx7Hr6/womBtJ
         V2p5qoctUKQL8LJolP2qOQHjpaAbgb0JH7Sqd1tqzekhtolthZ1rh7rAN9YsT31Cqidg
         5GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3UPj6T+LSG5RBZEWtvjbsFOKqjdqdXnS1AS9OtVMFac=;
        b=hF3iFK3H2d9xEyO27FRo31evHFigaXm567Nd5vHBdMbMP1o9jRhaTNyPFl2YtbkZqV
         n6iNrBepaNt/WuNdOao791zCxJ1ioAEHrneembJMPzEgn7xA0lAz7fQmvOXS6uVN1NS6
         j/P/3L608uCS+1V+lOfuZWi4gmf5nNJb8UaC4Gr9Sk3eEm8Wxy0/gYN4gP2dwzMSDsZX
         /L35h7VWV02T8vpJliQuGsqbw8s+5vu4SnyN4zsQAXw+xPcFlJtb2mi9gRjMJs9eYPG9
         dtU0i5IP566b8f6V+iWrW/IcLv8baj5q3fcPPonWIEr0uZ1QnIzAgizWbG9zDv5r9NON
         Xh5Q==
X-Gm-Message-State: APjAAAUKoh3N9ELnczdOHCllt17NuiPAKw8kQ79rw9PUyvY+5cOEg3jM
        BQk3Dw1w7eVleU45Kdo0UD3tfXS8KiytVt450FFHHQ==
X-Google-Smtp-Source: APXvYqxPh4CnW1rRI6+iCtk0bot5CEu74NPjsiMG/lkOrq+K7bOZUsw/H9b0vp3JyCBgf6D36Br7WRWJ/KWekfhUvCs=
X-Received: by 2002:ac2:514b:: with SMTP id q11mr8732236lfd.33.1563868564551;
 Tue, 23 Jul 2019 00:56:04 -0700 (PDT)
MIME-Version: 1.0
From:   erqi chen <chenerqi@gmail.com>
Date:   Tue, 23 Jul 2019 15:55:52 +0800
Message-ID: <CA+eEYqX6OkHEF0AhQ5E7DbSF16So7W0wiff=2uhgm9dmtsQGjQ@mail.gmail.com>
Subject: [PATCH] ceph: clear page dirty before invalidate page
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Erqi Chen <chenerqi@gmail.com>

clear_page_dirty_for_io(page) before mapping->a_ops->invalidatepage().
invalidatepage() clears page's private flag, if dirty flag is not
cleared, the page may cause BUG_ON failure in ceph_set_page_dirty().

Fixes: https://tracker.ceph.com/issues/40862
Signed-off-by: Erqi Chen chenerqi@gmail.com
---
 fs/ceph/addr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e078cc5..5ad63bf 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -914,9 +914,11 @@ static int ceph_writepages_start(struct
address_space *mapping,
                                dout("%p page eof %llu\n",
                                     page, ceph_wbc.i_size);
                                if (ceph_wbc.size_stable ||
-                                   page_offset(page) >= i_size_read(inode))
-                                       mapping->a_ops->invalidatepage(page,
-                                                               0, PAGE_SIZE);
+                                   page_offset(page) >= i_size_read(inode)) {
+                                   if (clear_page_dirty_for_io(page))
+                                       mapping->a_ops->invalidatepage(page,
+                                                               0, PAGE_SIZE);
+                               }
                                unlock_page(page);
                                continue;
                        }
--
1.8.3.1
