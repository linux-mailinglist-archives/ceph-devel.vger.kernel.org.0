Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471E826CEF9
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Sep 2020 00:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIPWlK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 18:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIPWlI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Sep 2020 18:41:08 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFD8C06174A
        for <ceph-devel@vger.kernel.org>; Wed, 16 Sep 2020 15:41:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m15so27791pls.8
        for <ceph-devel@vger.kernel.org>; Wed, 16 Sep 2020 15:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=Ogopkzr40pW1tKqjI+wHyoFBEn3yYD3OXpdPPOapvy7UiPI3VZlHScPO0DXPs/9+Mp
         qq49AE8DCgmRJuYr/XrYzBKd34hBzBa/5t//qfNskeeZt+JMpCCQFhqfionOkZ5bubEo
         vLzBHX5dtKSLDhm/r5/98Bkqek72sLBbuNTRVqUIgktfr5ymSgMrxOrblRViNnrPk7I2
         8iQ5d9GatDfXaw4G23SU67RnSCap64nkF2rDZlBRDwVmtES+hiaej8u9PALAsWq8ToAt
         oq0rnLw4o5n2eSDdT7hLuJG7AAxn9YRJYNL7GVYGhPwUev2vMYyx2bp+piZjHd1j2cRT
         nHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=CWLSgHj7cw5SbKlyyL2PHkr6o9K4UcmpACXpWk5adCwvTUg/XGm62Q4+g4Gs9WDtyN
         +vpAGOBrEp7v67+VdvM/vTv+HA/RA5yKHS4Z9BwVVOJIKbJyemcJXhGiyNbmOzpidWvt
         QWNk2pmGVKqLAMBjz307uCKec7pmHj6FsU2vtZ7C616ZB7hu8xKndFWqaFbO1zWIMC1m
         PUhW8vNGPmFKZbClz1/pK4Od8oA5OrhYbFkPd8NdsU7VfAjMR/xu3CX65MhRwbZ8e/Ot
         FrDy7gWDf5EyrR7re9k5P9OLsjhfjfAjLqAdqk2hiO+1L4i1m/RTSHuPzfGs5J7tdgu1
         3NcA==
X-Gm-Message-State: AOAM533oje76kUro5PLXveiAOf1d7LnithTGQChWr5BExeBLzjg5Qqik
        Wo4GVM7+kXNL7AJe3wFkgy5xrLZb1mY2hw==
X-Google-Smtp-Source: ABdhPJyfQourjAY03T+QMZ+HME/kxtbGOUiTrhjy7btX6rNuFeF3RBzo/K8ajbROBqvKKL7b7Kj4Ng==
X-Received: by 2002:a17:90a:b00e:: with SMTP id x14mr5851822pjq.212.1600296067463;
        Wed, 16 Sep 2020 15:41:07 -0700 (PDT)
Received: from ?IPv6:2605:e000:1600:d493:7057:dece:8f30:10d0? ([2605:e000:1600:d493:7057:dece:8f30:10d0])
        by smtp.gmail.com with ESMTPSA id e27sm17954121pfj.62.2020.09.16.15.41.06
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 15:41:06 -0700 (PDT)
From:   Dan Jakubiec <dan.jakubiec@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: 
Message-Id: <DD45753A-F168-4ED4-B7FD-1492466F02FB@gmail.com>
Date:   Wed, 16 Sep 2020 15:41:05 -0700
To:     ceph-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

unsubscribe
