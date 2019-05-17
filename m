Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E752C21421
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2019 09:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEQHXh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 May 2019 03:23:37 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:42195 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfEQHXg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 May 2019 03:23:36 -0400
Received: by mail-lf1-f54.google.com with SMTP id y13so4553384lfh.9
        for <ceph-devel@vger.kernel.org>; Fri, 17 May 2019 00:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5quDDeF8rbmlTqeK0dxWKmX/H391JDpYSiPkqKndDz4=;
        b=mElo3cJbY8evgL5I5akiOrbXcu13HDNY8r6cuYCcI0BDOoR6izIdzjHUthJO4FrelY
         fLlQcSlbWuuSgf4TM9GSY7mEzpGhCJwW7tdZMdUUNFyanw6ShXDmxJtcOVvQpxxtPapW
         p5Q7z2QVHtbioEGs3bSGsGRma0gD+RhgkM8VNa5zCf3iQwE8BNAiua0+eD12Lx+Rt65W
         PyODTp2RNeeIaqbiaL0J30E5bBf5mqyxkKnMRKEQFJMGbNTaNVeJIz6KSKjJ+BukMd4c
         vo8SYkEAAVlxI81pEXOr03CD8YpcNX/OBeMgivTw7Etz+3mfHzf/HxXzTXOMLSkPES1I
         M5qQ==
X-Gm-Message-State: APjAAAXSxdD0E0HlZbkjnlyQT6pWUNghh7dDDb2ERY0N8MwImrj/h++9
        Ih7r6JXXS4USSbK7mmWxF9ZuuatAHtww4Uc5tohjIo+MzFRdUA==
X-Google-Smtp-Source: APXvYqyMw8nArg4yG4KgbKmzrmHwQ2+QMRud92srRgr6+lbaw6aRkOgu69hdrRpQUqjGRbOQPS8hOuEMy3oaNHwQTTc=
X-Received: by 2002:ac2:5966:: with SMTP id h6mr11609186lfp.72.1558077814677;
 Fri, 17 May 2019 00:23:34 -0700 (PDT)
MIME-Version: 1.0
From:   Milind Changire <mchangir@redhat.com>
Date:   Fri, 17 May 2019 12:52:58 +0530
Message-ID: <CAED=hWDkQngRnF=mO_hiAyPSV5tAeSN7JgwjOQBXbwo-_d-WNw@mail.gmail.com>
Subject: When to use RadosStriper vs. Filer ?
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The idea is to use sqlite3 to work around the disk size constraint for
individual objects and/or their attributes (key-value pairs) so that
the Ceph implementation can manage/stripe the underlying data blocks
across OSDs seamlessly.

The implementation would be an sqlite3 VFS back-end interface to Ceph.
eg. metadata server (MDS) could create an sqlite3 database using this
new back-end to manage objects spread across OSDs

So, do I use the RadosStriper or the Filer class for the implementation ?

Or, do I need to tweak current implementation of some class(es) to get
the desired functionality in place to be used in the sqite3 VFS
interface implementation.

--
Milind
