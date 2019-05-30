Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9B2FC9A
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfE3Nqn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 09:46:43 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:43136 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfE3Nqn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 09:46:43 -0400
Received: by mail-lf1-f41.google.com with SMTP id u27so5056805lfg.10
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 06:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r++YujabgPa8NxvMfReRnULuTnG2RjrA974Fkh+pYYU=;
        b=nBSih/rgl6dblXu0TdLZ0bIj8vT+5AQIoI18se2MhgUMEX9xkanEUeogOE6OvJescy
         R4sk003mQbqAZdZe5geTyLlD0hvVvUiLRMiksoLAjbNGOUiLNuOf7stRbQd1HMG+Fr/I
         8FWSZeecKjKHzHAjWA52+zZoVLlw9qLrTsxqrwVDCDXHEIWOdd0SRYJBc0aV2AEIYCTG
         FWFus8SKTAVO20QP7aObbWeAs4O77y+cgwpkAV/t02T7JEAZi++S29ar2A93cDk3Ar4o
         dvPxIQ4bTHuPDc6A/tDrLsLAAiyYUFFq4PFGkfbKkl1HYW94YLcNrlscilIAjgGc56vV
         bELg==
X-Gm-Message-State: APjAAAWYtQaGCJEgblYip5q1qqG+bxCwKkPVTd249mLqMTBn8alziTLr
        lBwm3aBydXc7EwHSSmlNjo10CnoicBILN124bzVm2kAl
X-Google-Smtp-Source: APXvYqwnhnXaUS1lEfBKF9bx+ZEZ38ZK0WliTRTa5e+S7stIHO9MhQj0dnYDcWay5N8KDfHogg1wYs9y5CrO/hFk1P0=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr2287793lfh.15.1559224001488;
 Thu, 30 May 2019 06:46:41 -0700 (PDT)
MIME-Version: 1.0
From:   Milind Changire <mchangir@redhat.com>
Date:   Thu, 30 May 2019 19:16:05 +0530
Message-ID: <CAED=hWDpWZf1Oo-9QEKhW7Hdeg7LHsN3vANKxcCHY50nnO4VQQ@mail.gmail.com>
Subject: does Filer support caching ?
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Does class Filer support caching ?
Or
Where in the client stack is caching implemented for libcephfs ?

-- 
Milind
