Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07C37D16
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfFFTPu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 15:15:50 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37715 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbfFFTPu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 15:15:50 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so2199427qkl.4
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 12:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i2G7XApa4qYRDLh0iesXmVak2Gwm7NIrIFlC9ENg1aI=;
        b=nPMHjKLaXxjJP/HycqWV75pwPNaXaq40andTXc7SNuXvfz+/Rd9bPbFXI/nIAMQr9U
         GA32mvIztE5IudawEKN6KtQuwzpmELbZA0ZZ1EQjce5/xyj52OSvqf62WbClT4yIyhJD
         Jx9jpB2Er7n15jiLb421+7Euu11LaNADO0kSG1+hcC6+j4eBx2j4QJFiDyNQzFlNg6OJ
         +OdyKOdYYIAibuaiSKMinhfECY+lPyW/G91mfSWOpBYpz0qJskhZRNX0CzYRNYlXILi8
         tFZt/LUUATu4ExrQscU16vmGjheo6bz8BfUximau+GASztquO+LFQFX5bJeqhvnDhOQT
         ZSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=i2G7XApa4qYRDLh0iesXmVak2Gwm7NIrIFlC9ENg1aI=;
        b=XiiWcp0MbQCNQgetYC5GeMQGDCOWQee6X+xJyFQ3p/RLA28mHofjy+dhRIDLigT9D/
         1SRfn/kxaAZQvZYqD3/Baml9VSZ/Fu0r08fni//s25UGBhpE5pV4Q96/LHJuMP1YQzoi
         ethKoz4f2rugx0GlE7Ujsqy2ZCMRZTdbUthGc0zVAiDq0YbruHJToT0A+3Rx5eaY5xic
         NkjtrKAMk0X9zC7aNJ3lpvfzS2Y0axuol3+ouUKN9gsCkfDvAc94hbmJsmpR1C9yJmxv
         cxFDltiqI0eUoQWo7RIyAshCWoiQy8cNuKiK+1BSuAKlTeDuKtDBq1EgCU+A5wqkBm8Q
         hYGw==
X-Gm-Message-State: APjAAAX3RdtPB4xbEXxZXeAmgT35gVoITpy4jVEUzoVLLj0vzIeVZG/o
        ZwgwKrzx9Kb3c4+/H9rXVLo=
X-Google-Smtp-Source: APXvYqygh4DgwmHFtd3KCXb1z5bmCZ6f8eMg8XKZ67DiPG41hkbT0YAsab2DG4hEXJt64b/z7mpYAw==
X-Received: by 2002:a37:6a87:: with SMTP id f129mr25188719qkc.183.1559848549318;
        Thu, 06 Jun 2019 12:15:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::1:c027])
        by smtp.gmail.com with ESMTPSA id j1sm1980464qtc.26.2019.06.06.12.15.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 12:15:48 -0700 (PDT)
Date:   Thu, 6 Jun 2019 12:15:45 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xxhdx1985126@gmail.com, idryomov@gmail.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, Xuehan Xu <xxhdx1985126@163.com>
Subject: Re: [PATCH 0/2] control cephfs generated io with the help of cgroup
 io controller
Message-ID: <20190606191545.GR374014@devbig004.ftw2.facebook.com>
References: <20190604135119.8109-1-xxhdx1985126@gmail.com>
 <52aacd32597d3f66b900618d7dddd52b6bd933c7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52aacd32597d3f66b900618d7dddd52b6bd933c7.camel@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

On Thu, Jun 06, 2019 at 03:12:10PM -0400, Jeff Layton wrote:
> (cc'ing Tejun)

Thanks for the cc.  I'd really appreciate if you guys keep me in the
loop.

-- 
tejun
