Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE8AC12F6
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Sep 2019 05:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfI2D7V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 28 Sep 2019 23:59:21 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:37189 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI2D7V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 28 Sep 2019 23:59:21 -0400
Received: by mail-oi1-f181.google.com with SMTP id i16so8394113oie.4
        for <ceph-devel@vger.kernel.org>; Sat, 28 Sep 2019 20:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2M60tEhZ4SII3SUThXEjKW23PWiEOzZ6s+ucS9NwcOc=;
        b=BcHeRvPvhDcoinkO2hI+dhunbilq0jpSTOu1vRyXYdHOPqMpBMLiibcEgrbFqjNWNa
         WsG8SZJs4dNfY55IUE5wFFe1zPXpmFlOTg6HUsuXMmb3S2oeZPHTYoAHX5B+hoTfPJ5z
         /2f2P0nBFHWW6PH3wV0txTX6uigY4C9xYWVNzEbMrpPvJ0RGxY8qJuCjw1xpGlE154bv
         RI5/Gp9By3snvsa21evAly2yRJ9+lW7Tz0Cu1cbiHHGN5ujSUAshTAcQXeFpxnmKhFjd
         QrogBiHhggGv1vsqdXkVifgAitvyQIQFvzEKSk/oKWkztxVYkCsFAw88w4J2R1FO+8fZ
         ZA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2M60tEhZ4SII3SUThXEjKW23PWiEOzZ6s+ucS9NwcOc=;
        b=FjfI8uREht1obQtzUGDs3dG39rUd7G1fTZVZXLS9/fesGmDap9KrsxPXN/Lvc+EKBG
         g8hYVHd/QlppDOIiE3n2UJRxZD8CmsjAoGbYPAH3fTAkBfqh4sq0nawOgwJexloGIV3+
         W5nGWULNf9MI5OeJAa95iElVBV18ej9P40HOnQ9j05cn7H1GzB8ZvMtvAe6mHizYPdDM
         8CsRGe5YVsHackwXmXzJUyuRuJFHdsp4gqqTTZvRj+LA1bSsSGKDyJ0csSRuvR/tZnvA
         HQj1Z8sb9mh597TCKVq5t3dtLEcWg6laaJzE4T5CYEAH0x8ysnqtYaah5FBLljJE3xkS
         UbWA==
X-Gm-Message-State: APjAAAVY9v+zLt2v7yPphoKA6Hb5vn6H29H6DznOMxxO7sfDTPERNkHY
        ptj6YWK+oNFQqIaUFUXZ6ILk1nR9/jnv1Yj1anEjPVNp
X-Google-Smtp-Source: APXvYqym/zPxg6q08yXZ0k8LjmZBblztljPsZr9U7vEC7G1OpJPWzLOqw5ocYDLtegrd5uaJwnMmZ6LrvtHECZ4cZ9o=
X-Received: by 2002:aca:5dd4:: with SMTP id r203mr13124040oib.67.1569729560600;
 Sat, 28 Sep 2019 20:59:20 -0700 (PDT)
MIME-Version: 1.0
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Sun, 29 Sep 2019 11:59:09 +0800
Message-ID: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com>
Subject: Why BlueRocksDirectory::Fsync only sync metadata?
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, everyone.

I'm trying to read the source code of BlueStore. My question is why it
is sufficient to only flush the log in BlueRocksDirectory::Fsync?
Shouldn't it flush the file data first? Is it because rocksdb always
flush file data before doing fsync? Thanks:-)
