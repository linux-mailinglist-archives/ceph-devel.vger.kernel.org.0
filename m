Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B642D5C22
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Dec 2020 14:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbgLJNnC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Dec 2020 08:43:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389272AbgLJNnB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607607695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HZTUjuzeKd/6kKP5i7HqoxPI+kvU4XzKFLMyuqkRhM0=;
        b=Su2o4bawpK3fn9SSBaihW5cRPht8YFkq3Pjrry+9/Oi0lJDo7SLMuTvKVdNBohpakLFwH+
        xD6biOJqXkRZmM7HwM6mZcNxfCyGdJl4X952AnEyuRsH0MIxBCsvx77Xo3sdOmxw3QVeca
        WwK6pSdeBKPVZJb76IQs+iflAm/LgQQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-HpU3lsH5Pc2aEevrMwgXvg-1; Thu, 10 Dec 2020 08:41:33 -0500
X-MC-Unique: HpU3lsH5Pc2aEevrMwgXvg-1
Received: by mail-pf1-f197.google.com with SMTP id b11so3758494pfi.7
        for <ceph-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:41:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZTUjuzeKd/6kKP5i7HqoxPI+kvU4XzKFLMyuqkRhM0=;
        b=sLRHnDzIw4qHAopPAYdrPVUds8PdLRHzxWKzlgm1KtSQgbPohGId9Beh2puWKh+m1+
         wbhfWmikT2BpM0py8aBIw6bBl6WO2+CTGTd7ANJK6tVOyeyiYu534PbSkFMqlLVjPLGR
         gLJpua8SsBZJQCSzKsDNCsDLmup0P1P4/+uJ5y5mzAKXCYmg6PayzUXehZQ1EZF4FteX
         KgpYFFwK8dehmooicRG20QR75BA5DKOpJ2EkmcOdfZuMMIaJN5YVfRqTIFp/Ons2pJVV
         8xKDiNqcpyN5bv7ROloPqTfRj5wv0oeIsXDAWdaSaP8zDXXfOFK8YVGnMmZY3N5Ou1CD
         VBgQ==
X-Gm-Message-State: AOAM532aMhEuOkJRh47T9ExAwtriYKAoP/I1tsgs0ISO3Dty9FXHGK2g
        BsV1pE9fW4AQ2pqW/H7MysvJsYdGyBt2DglRTmXko6J7TnaFuIHisgjpMezRgcqzDpdcrYpE2I/
        KrIB0N7kgXGH7QC3i2BWasTbExwCAs2LdcG1K5g==
X-Received: by 2002:a17:902:7c95:b029:da:9461:10da with SMTP id y21-20020a1709027c95b02900da946110damr6792380pll.42.1607607692401;
        Thu, 10 Dec 2020 05:41:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQ0mGO9/iK+b2rKFda3f35P16HSTrgVadTpPGVmRemffwZzFMJqNl3PMa8AsBP5NSt0gsWVfPKxgQIiwR0MzM=
X-Received: by 2002:a17:902:7c95:b029:da:9461:10da with SMTP id
 y21-20020a1709027c95b02900da946110damr6792358pll.42.1607607692155; Thu, 10
 Dec 2020 05:41:32 -0800 (PST)
MIME-Version: 1.0
References: <CAPy+zYXDg4xFLiRE6e5iKZLokq2zSRNZrorPsbO68K=OW5SN8w@mail.gmail.com>
In-Reply-To: <CAPy+zYXDg4xFLiRE6e5iKZLokq2zSRNZrorPsbO68K=OW5SN8w@mail.gmail.com>
From:   Matt Benjamin <mbenjami@redhat.com>
Date:   Thu, 10 Dec 2020 08:41:23 -0500
Message-ID: <CAKOnarmeKE8EkwYqm5XtqnQnyYPchO7RLosr5BMw7eH83yPM1A@mail.gmail.com>
Subject: Re: ceph rgw memleak?
To:     WeiGuo Ren <rwg1335252904@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi WeiGuo,

I'm not aware of a memory leak in RGW, but in the past when we've
suspected one, we used valgrind massif against radosgw for a
representative time sample to get a picture of memory behavior in the
program.  That might be a way to start.

Matt

On Thu, Dec 10, 2020 at 8:14 AM WeiGuo Ren <rwg1335252904@gmail.com> wrote:
>
> In my ceph version 14.2.5.ceph radosgw mem is high (4.6g use top
> command).when I write 20m.
> I noticed dump_mempools's buffer_anon is very high (3-4g)in
> testing,after test,the buffer_anon has been release(about10m). but rgw
> mem is still high(about 4.6g).So i think maybe some memleak occurred
> in rgw.
> Could someone can help me? or Could someone tell me how to tune rgw-memory?
>


-- 

Matt Benjamin
Red Hat, Inc.
315 West Huron Street, Suite 140A
Ann Arbor, Michigan 48103

http://www.redhat.com/en/technologies/storage

tel.  734-821-5101
fax.  734-769-8938
cel.  734-216-5309

