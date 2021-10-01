Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1529541F648
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 22:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354891AbhJAU0g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 16:26:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhJAU0f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 16:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633119888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP1U9Tjsru03cnpUEc5TglDhT3I54WdtbEW4DRdZ0+4=;
        b=SVv9fFuxedEGsTeU/99vqSG1QX1IdDxNRYagf4NracSVA+FqOfSY6HFYZ8oeZpBuyTT7sl
        +FthyQPQ1ZMywWKxH0uh94R/4CcoQV4667+SI7NCgekijVDqSGIg9MUEHa0pR8Bxq/qAUR
        v1Haj1y9HyINnt3nmmxvgtnpfBEpwYY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-9eaq07KZMwW8SWjyqQ6B4g-1; Fri, 01 Oct 2021 16:24:47 -0400
X-MC-Unique: 9eaq07KZMwW8SWjyqQ6B4g-1
Received: by mail-qv1-f70.google.com with SMTP id kc13-20020a056214410d00b00382bc805781so2282881qvb.12
        for <ceph-devel@vger.kernel.org>; Fri, 01 Oct 2021 13:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RP1U9Tjsru03cnpUEc5TglDhT3I54WdtbEW4DRdZ0+4=;
        b=VnJfHWCSPgwPyO1Z+wdYU4iP4ca/YYixXqQJ5vYlrtlS31TbragoloUWKdJxjbiDEd
         5IT6g39gJ7YQhawErGPAx0YZ3vbs82Vx2BIHEc0gE2RrJv5lPnE4LZFbrZVYLmN14hMT
         XWaujvkIjPS4fmJOL+jhlsxYJrw1hKsywjF8s8PZVdTryAGr9TBFesPkWAVX5H8RPwPa
         DQj4LZHDKOo+Y5WDBeiouXcGpKIDyY6aGpP2uj8ELlJiRhAZMcNMdhcwdRN5lDgFTYT2
         893Sz8FClqpNTtOQZSwVqSjfyA6EUG4nhrgmqSINyNX1tsLMRoHQZVCtqYRJ/prAcbMR
         X2Bw==
X-Gm-Message-State: AOAM532oEh77oS1B7LsTduBGCqlUwTHmLxLzascvI3zsJiA3hakq3102
        vbYq19OiFFEVHF25dGLAB11uxxelvO3bTmDF551d0yiNM7sOXuTPjkXps4W7Vvf7KwOe5RNdVa0
        WFogaYeMuDNC4Kx7RpFw3fw==
X-Received: by 2002:a05:622a:316:: with SMTP id q22mr7196967qtw.225.1633119886600;
        Fri, 01 Oct 2021 13:24:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPNzOmNoyFTvE8UvzhvHxu/ZRO+0PjVN29MwtLDODuOSPmMWRMEJmMaxHqv/6ObGArAgI+IQ==
X-Received: by 2002:a05:622a:316:: with SMTP id q22mr7196944qtw.225.1633119886397;
        Fri, 01 Oct 2021 13:24:46 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id z9sm3801270qtf.95.2021.10.01.13.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 13:24:45 -0700 (PDT)
Message-ID: <32e55634cc84b93ae70598f538b4a74f92c6907f.camel@redhat.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 01 Oct 2021 16:24:45 -0400
In-Reply-To: <CA+2bHPYGr4rpJhHb_aX3j-7iYa-tQMfjOmNL6T7R_+26HrUY3A@mail.gmail.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
         <e0f529e2e17cb886bd6a906541fb978be45e0e4e.camel@redhat.com>
         <CA+2bHPYGr4rpJhHb_aX3j-7iYa-tQMfjOmNL6T7R_+26HrUY3A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-10-01 at 16:18 -0400, Patrick Donnelly wrote:
> On Fri, Oct 1, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote:
> > Note that there is a non-zero chance that this will break teuthology in
> > some wa. In particular, looking at qa/tasks/cephfs/kernel_mount.py, it
> > does this in _get_global_id:
> > 
> >             pyscript = dedent("""
> >                 import glob
> >                 import os
> >                 import json
> > 
> >                 def get_id_to_dir():
> >                     result = {}
> >                     for dir in glob.glob("/sys/kernel/debug/ceph/*"):
> >                         mds_sessions_lines = open(os.path.join(dir, "mds_sessions")).readlines()
> >                         global_id = mds_sessions_lines[0].split()[1].strip('"')
> >                         client_id = mds_sessions_lines[1].split()[1].strip('"')
> >                         result[client_id] = global_id
> >                     return result
> >                 print(json.dumps(get_id_to_dir()))
> >             """)
> > 
> > 
> > What happens when this hits the "meta" directory? Is that a problem?
> > 
> > We may need to fix up some places like this. Maybe the open there needs
> > some error handling? Or we could just skip directories called "meta".
> 
> Yes, this will likely break all the kernel tests. It must be fixed
> before this can be merged into testing.
> 

Ok, I'll drop these patches for now. Let me know when it's clear to
merge them again, and I'll do so.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

