Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F678146FD2
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2020 18:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWRgZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jan 2020 12:36:25 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:45439 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAWRgZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jan 2020 12:36:25 -0500
Received: by mail-wr1-f47.google.com with SMTP id j42so4005995wrj.12;
        Thu, 23 Jan 2020 09:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j89wpIoc10FuVTnXzWiXtkXlemWTCqBszJnT6eXVcBk=;
        b=jgSPr73m/p+KyektYK9I1dgwJ6s1yZeoxAXj8h7jP0sxigJF8u1b36TebeshRSsYdl
         4fyvVcp7sJpB/pt4oS7dnzpA9+kGJJSWtaMN3ftsqSo/X+mXEIZBmzvtHuhb+hTGESCI
         PUUp3VQ8zEMK3q5tZwJ0UhSG1JwYovhqTIReKJTpvspeLGe/v9foz6gMSFM9lAPrL/8O
         4Cb5GuCvIWDoTfIJVNbAwkGBpMZeI+uQOIFd5J8spXYOUK5XbpzmNKRVB9VCKMG6krLG
         3PhFL5RfaDH2+UOkBeDn/kxc7J/PZd8Fz744HC4XWQb39pJDKTQBVBolS/E5x2ItxIHj
         oxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j89wpIoc10FuVTnXzWiXtkXlemWTCqBszJnT6eXVcBk=;
        b=fCgKv2vu8XLmvc0Tz5C4PJZqQT/bDTlNC649q7B3/6ScdDqyiYWqZ0Rm7tD+TWR2S9
         jcE682tlm3P7AfR0+HHYXOiJe638Ukuuxme5xesdQw97u+7PeP3e6owdc+i94QZeGaNY
         6ewbkwwuqjKqZJYMr+kZaqTUVHSt3k1UOLI3O+BV4uKU5kku75UYdNwIZdCEEK2AvZ1k
         QrhQaInWrcXReAGpgi4kvxfEdcUkZs6In67B0d8RicXYFgCbKsMSST6AzgKKWc+yyCFd
         a6vqW/gmCHk6h6C2o20Pu/L7CI+J+qUmvqDQFsAYjKZjLH0SeLhHR6dMJ6ayHE7lTnAT
         p1Pg==
X-Gm-Message-State: APjAAAWo10z5GGjre/dnM/4KnBfX3TrYMj8wvZ/ECjM7iYLYrM19Y1su
        AUQxqnjVgylxi6SXxyO5IdhQdDNe/q4=
X-Google-Smtp-Source: APXvYqwJdMe+Io2xF/lEf0pSQVCGy8TWKyqfAe9IgnVvdXZVMXMOoQDPuAwtwpX1MsujjlWkt5kUwA==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr18454554wrm.131.1579800983488;
        Thu, 23 Jan 2020 09:36:23 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q3sm3385947wmc.47.2020.01.23.09.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:36:22 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 5.5-rc8
Date:   Thu, 23 Jan 2020 18:36:29 +0100
Message-Id: <20200123173629.18402-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit def9d2780727cec3313ed3522d0123158d87224d:

  Linux 5.5-rc7 (2020-01-19 16:02:49 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.5-rc8

for you to fetch changes up to 9c1c2b35f1d94de8325344c2777d7ee67492db3b:

  ceph: hold extra reference to r_parent over life of request (2020-01-21 19:02:37 +0100)

----------------------------------------------------------------
A fix for a potential use-after-free from Jeff, marked for stable.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: hold extra reference to r_parent over life of request

 fs/ceph/mds_client.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
