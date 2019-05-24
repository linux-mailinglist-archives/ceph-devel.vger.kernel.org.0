Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63929E26
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbfEXSe6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 14:34:58 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:34589 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbfEXSe5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 14:34:57 -0400
Received: by mail-vs1-f48.google.com with SMTP id q64so6496147vsd.1
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 11:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=D5Wf2DK0LuaABYDxknoiDAYECfM6giolae5oW6bcPYQ=;
        b=udhqEy7C/lZENKgjsiFQ9xzVyqv/KwVQlTzdsw4eLqsir09WjqivqHQHiXNLO4zKp6
         InIaXqa4s7fPyM3ivy1xtmt5Wz+/bkF7foCvCd5tbza8ev2L2a9dxwUHzwk2+/1j2oOR
         AQfreGHXd22bl9oavNmF+y3Cjj7WsexrdYOAZsBgOua3lQ8Ivmr6JEbLYTcorTFXd9t1
         6V3wFO1Uvw8ETfWEo7vVPGOSqX8D8yYU0HMtxetbb+Zf6I1oDm+zaScQxuttPvowME2l
         SlK+1NZ5ny98YHW2wqiA5CMdVT2yWi9uVOTiHzAbD2+bEDPBYJ6mV2kaNHT/ioDrmUeA
         PJNg==
X-Gm-Message-State: APjAAAX0ZImcml5oI9ejBH4DT2kbn+12hn+p7MECtwbPKV/Gyp/uOl/M
        zjhzoEE6qqgCCaZh2RIeUQu7aw==
X-Google-Smtp-Source: APXvYqw7C+3sRedk6/wcG5znXPfYXrnU943N6vaaTQ052Yz+SrV1RqsCHI6lUx76ikuls2eS7SVvTA==
X-Received: by 2002:a67:e98e:: with SMTP id b14mr47956038vso.145.1558722896618;
        Fri, 24 May 2019 11:34:56 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id x19sm1313796vsq.9.2019.05.24.11.34.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 11:34:55 -0700 (PDT)
Subject: Re: 13.2.6 QE Mimic validation status
To:     Yuri Weinstein <yweinste@redhat.com>, Sage Weil <sweil@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        "Deza, Alfredo" <adeza@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Message-ID: <cf95feb1-3fce-5634-cdbc-8840c8de954d@redhat.com>
Date:   Fri, 24 May 2019 14:34:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/23/19 4:00 PM, Yuri Weinstein wrote:
> Details of this release summarized here:
>
> http://tracker.ceph.com/issues/39718#note-2
>
> rados - FAILED, known, Neha approved?
> rgw - Casey approved?
rgw looks good, thanks Yuri
> rbd - Jason approved?
> fs - Patrick, Venky approved?
> kcephfs - Patrick, Venky approved?
> multimds - Patrick, Venky approved? (still running)
> krbd - Ilya, Jason approved?
> ceph-deploy - Sage, Vasu approved?  See SELinux denials, David pls FYI
> ceph-disk - PASSED
> upgrade/client-upgrade-jewel - PASSED
> upgrade/client-upgrade-luminous - PASSED
> upgrade/luminous-x (mimic) - PASSED
> upgrade/mimic-p2p - tests needs fixing
> powercycle - PASSED, Neha FYI
> ceph-ansible - PASSED
> ceph-volume - FAILED, Alfredo pls rerun
>
> Please review results and reply/comment.
>
> PS:  Abhishek, Nathan I will back in the office next Tuesday.
>
> Thx
> YuriW
