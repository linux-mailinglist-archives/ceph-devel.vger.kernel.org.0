Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F476C800
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jul 2019 05:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389289AbfGRDgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Jul 2019 23:36:04 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:40543 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389084AbfGRDgE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Jul 2019 23:36:04 -0400
Received: by mail-lf1-f48.google.com with SMTP id b17so18074245lff.7
        for <ceph-devel@vger.kernel.org>; Wed, 17 Jul 2019 20:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=NWyUaX2M7WVy8/r17ZiFMNi37Gdu/bFfTK9ovHmU+raVCDr89fq12v19vyDLMaqsvJ
         cl6BUcm1aesxzrZHTFFNn7fyuCqvB39EfaULJJFigRXB5gTTo7Fz3F1t5n9AuQsQO8f1
         b8JflGT4KE/tnzK8j7NisvcV1+fR5ySKlLAOtSsetAhAbeiPsByvz2y38IfhWbUd7/DT
         2I5VUW44QDCHjBnEJbLtx+CJmNNRXt3Y2RPxitcvdaenzoF17Zq2LbInMHrWXwdQbqsW
         G+NCVMkeeLiLjWFVKY49CXaocSnEascm/d93SG2oxXWg45Nk6k+9At67gpBecM8Z/U6+
         EluQ==
X-Gm-Message-State: APjAAAXZTmcZRvsYe1jutl1VKJDnlc0gX5uQmskUW0ZvdlndcMIy6cN6
        Pw963zv8farLUvX4OkH0ey6H+jN1eFVRzaGhSkDntuARAIA=
X-Google-Smtp-Source: APXvYqxjlh/R/+KUs4jXYPZOLxiQmSUpcPociKzEdhcvShNvqH1sqkqR//kZCvw3cGjYs308QSKK0pHBSOY8kJWjAkY=
X-Received: by 2002:a19:ca0d:: with SMTP id a13mr19095669lfg.110.1563420962315;
 Wed, 17 Jul 2019 20:36:02 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 18 Jul 2019 13:35:51 +1000
Message-ID: <CAF-wwdGyvNojcL26hotQRx5DR-EGn6m8GgrX1TpLBHQ3WcManw@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
