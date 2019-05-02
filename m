Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1E611AD5
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfEBOI0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 May 2019 10:08:26 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:35800 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBOI0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 May 2019 10:08:26 -0400
Received: by mail-qk1-f175.google.com with SMTP id b7so1506508qkl.2
        for <ceph-devel@vger.kernel.org>; Thu, 02 May 2019 07:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nhi5ZNLwlro3XiHGA0FYrwToo2t4hrtETPn8gLfPbfc=;
        b=h9BF7vcELh8t9qUql8yGlON8susctGXwHHfJoh9wvbzdf4hd7NuGwDHPgbQoS1t3yX
         /5kH4L0tDWNDIIEMcaq+TDJQl+LFXYpUwddRXNCMFgbYP6wJOps6E4SeDUzbCgcY+PKT
         RWnK9YUcg3Oi2ModljtyB9rQimtTqXBi+6IrGQ+/p1QWNYWEUmQKZW+kWjHxcTcngZ+z
         tnlxiuXuThMQaHiwPNcJLLJT7SvDcYaBirqGmPdxj5HQdD2jCTbM/PT0Yapcu60ZNhme
         7aEEUR6PBpiKUf+Sj1+osyV3riK0p8fUwDu1UroDkmhugc8nfdmUcR0zNB9lrYXN17fe
         d+2Q==
X-Gm-Message-State: APjAAAULImFc8LG221IM7nTtlWAiyQQ+t5hHa6VFkJW7wbQAbKdk6EBy
        +QvZpyisSTuJD7Jv5DrbEAhcnA==
X-Google-Smtp-Source: APXvYqz47z+Ots9wFHAqM6biVuCoex9gaNXK6OWJs/cH+fE71qnyVE526vWjL/FC3VmE4wppq9mUhw==
X-Received: by 2002:a37:4b41:: with SMTP id y62mr3086573qka.104.1556806105340;
        Thu, 02 May 2019 07:08:25 -0700 (PDT)
Received: from sidious.arb.redhat.com ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id m31sm27836778qtm.46.2019.05.02.07.08.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 07:08:24 -0700 (PDT)
Reply-To: dang@redhat.com
Subject: Re: [ceph-users] RGW Beast frontend and ipv6 options
To:     Abhishek Lekshmanan <abhishek@suse.com>,
        ceph-devel@vger.kernel.org, ceph-users@lists.ceph.com
References: <87a7gdgngp.fsf@suse.com>
From:   Daniel Gryniewicz <dang@redhat.com>
Organization: Red Hat
Message-ID: <613006e7-62d9-a03f-f8d7-5a37ef1ffb88@redhat.com>
Date:   Thu, 2 May 2019 10:08:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <87a7gdgngp.fsf@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Based on past experience with this issue in other projects, I would 
propose this:

1. By default (rgw frontends=beast), we should bind to both IPv4 and 
IPv6, if available.

2. Just specifying port (rgw frontends=beast port=8000) should apply to 
both IPv4 and IPv6, if available.

3. If the user provides endpoint config, we should use only that 
endpoint config.  For example, if they provide only v4 addresses, we 
should only bind to v4.

This should all be independent of the bindv6only setting; that is, we 
should specifically bind our v4 and v6 addresses, and not depend on the 
system to automatically bind v4 when binding v6.

In the case of 1 or 2, if the system has disabled either v4 or v6, this 
should not be an error, as long as one of the two binds works.  In the 
case of 3, we should error out if any configured endpoint cannot be bound.

This should allow an orchestrator to confidently install a system, 
knowing what will happen, without needing to know or manipulate the 
bindv6only flag.

As for what happens if you specify an endpoint and a port, I don't have 
a strong opinion.  I see 2 reasonable possibilites:

a. Make it an error

b. Treat a port in this case as an endpoint of 0.0.0.0:port (v4-only)

Daniel

On 4/26/19 4:49 AM, Abhishek Lekshmanan wrote:
> 
> Currently RGW's beast frontend supports ipv6 via the endpoint
> configurable. The port option will bind to ipv4 _only_.
> 
> http://docs.ceph.com/docs/master/radosgw/frontends/#options
> 
> Since many Linux systems may default the sysconfig net.ipv6.bindv6only
> flag to true, it usually means that specifying a v6 endpoint will bind
> to both v4 and v6. But this also means that deployment systems must be
> aware of this while configuring depending on whether both v4 and v6
> endpoints need to work or not. Specifying both a v4 and v6 endpoint or a
> port (v4) and endpoint with the same v6 port will currently lead to a
> failure as the system would've already bound the v6 port to both v4 and
> v6. This leaves us with a few options.
> 
> 1. Keep the implicit behaviour as it is, document this, as systems are
> already aware of sysconfig flags and will expect that at a v6 endpoint
> will bind to both v4 and v6.
> 
> 2. Be explicit with endpoints & configuration, Beast itself overrides
> the socket option to bind both v4 and v6, which means that v6 endpoint
> will bind to v6 *only* and binding to a v4 will need an explicit
> specification. (there is a pr in progress for this:
> https://github.com/ceph/ceph/pull/27270)
> 
> Any more suggestions on how systems handle this are also welcome.
> 
> --
> Abhishek
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
> 

